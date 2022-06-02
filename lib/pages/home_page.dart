import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thunder_chat_app/cubits/auth/auth_cubit.dart';
import 'package:thunder_chat_app/cubits/fetch_chat/fetch_chat_cubit.dart';
import 'package:thunder_chat_app/cubits/get_user_chats/get_user_chats_cubit.dart';
import 'package:thunder_chat_app/cubits/image_picker/image_picker_cubit.dart';
import 'package:thunder_chat_app/cubits/users/users_cubit.dart';
import 'package:thunder_chat_app/utils/error_dialog.dart';
import 'package:thunder_chat_app/widgets/drawer.dart';

import '../widgets/chat_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final userID = context.read<AuthCubit>().state.user!.uid;
    // print('user ID: ${userID}');

    context.read<FetchChatCubit>().getSnaps(userID: userID);
    context.read<GetUserChatsCubit>().getUserChats(userID: userID);
    context.read<UsersCubit>().getOneUser(userID: userID);
  }

  @override
  Widget build(BuildContext context) {
    final String loggedUser =
        context.watch<UsersCubit>().state.loggedUser.userName;

    return WillPopScope(
      onWillPop: () async => false,
      child: MultiBlocListener(
        listeners: [
          BlocListener<FetchChatCubit, FetchChatsState>(
            listener: (context, state) {
              if (state.fetchChatsStatus == FetchChatsStatus.error) {
                errorDialog(context, state.customError);
              }
            },
          ),
          BlocListener<GetUserChatsCubit, GetUserChatsState>(
            listener: (context, state) {
              if (state.getUserChatsStatus == GetUserChatsStatus.error) {
                errorDialog(context, state.customError);
              }
            },
          ),
        ],
        child: Scaffold(
          drawer: const Drawer(
            child: MyDrawer(),
          ),
          appBar: AppBar(
            title: Text(loggedUser),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<ImagePickerCubit>().state.imagePath = null;
                  context.read<AuthCubit>().signOut();
                },
                icon: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
          body: BlocBuilder<GetUserChatsCubit, GetUserChatsState>(
            builder: (context, state) {
              if (state.getUserChatsStatus == GetUserChatsStatus.loading ||
                  context.read<FetchChatCubit>().state.fetchChatsStatus ==
                      FetchChatsStatus.loading) {
                return Center(child: CircularProgressIndicator());
              }
              if (context.read<UsersCubit>().state.userStatus ==
                      UserStatus.loaded &&
                  context
                      .read<FetchChatCubit>()
                      .state
                      .docSnapshotList
                      .isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Welcome ${loggedUser} you dont have any message yet',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              if (state.getUserChatsStatus == GetUserChatsStatus.loaded &&
                  context
                      .read<FetchChatCubit>()
                      .state
                      .docSnapshotList
                      .isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.chatsList.length,
                  itemBuilder: (context, index) {
                    final chat = state.chatsList[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: chatWidget(
                        chat: chat,
                        context: context,
                        id: context.read<AuthCubit>().state.user!.uid,
                        reciverID: chat.userID,
                      ),
                    );
                  },
                );
              }
              if (state.getUserChatsStatus == GetUserChatsStatus.error) {
                return Center(
                  child: Text('Error'),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
