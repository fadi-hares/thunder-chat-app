import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thunder_chat_app/cubits/auth/auth_cubit.dart';
import 'package:thunder_chat_app/cubits/fetch_messages/fetch_messages_cubit.dart';
import 'package:thunder_chat_app/cubits/users/users_cubit.dart';
import 'package:thunder_chat_app/models/user_models.dart';
import 'package:thunder_chat_app/utils/error_dialog.dart';

import '../cubits/chat/send_message_cubit.dart';

class ChatPage extends StatefulWidget {
  final String reciverName;
  final String reciverID;
  final String reciverImage;
  final String reciverEmail;
  static const routeName = '/chat-page';
  const ChatPage({
    Key? key,
    required this.reciverEmail,
    required this.reciverName,
    required this.reciverID,
    required this.reciverImage,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  late UserModel userModel;
  late User user;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    user = context.read<AuthCubit>().state.user!;
    userModel = context.read<UsersCubit>().state.loggedUser;
  }

  void _submit() async {
    if (_controller.text.trim().isNotEmpty) {
      await context.read<SendMessageCubit>().sendMessage(
            senderID: user.uid,
            reciverID: widget.reciverID,
            senderEmail: user.email!,
            reciverEmail: widget.reciverEmail,
            senderName: userModel.userName,
            reciverName: widget.reciverName,
            senderImage: userModel.userImage,
            reciverImage: widget.reciverImage,
            message: _controller.text,
          );
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    print(user.uid);
    // print(widget.reciverName);
    return MultiBlocListener(
      listeners: [
        BlocListener<SendMessageCubit, SendMessageState>(
          listener: (context, state) {
            if (state.sendMessageStatus == SendMessageStatus.error) {
              errorDialog(context, state.customError);
            }
          },
        ),
        BlocListener<FetchMessagesCubit, FetchMessagesState>(
          listener: (context, state) {
            if (state.messagesStatus == MessagesStatus.error) {
              errorDialog(context, state.customError);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.reciverName),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.reciverImage),
              ),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: context
              .watch<FetchMessagesCubit>()
              .fetchMessage(userID: user.uid, reciverID: widget.reciverID),
          builder: (context, snapshot) {
            final chatDoc = snapshot.data?.docs;

            return Column(
              children: [
                chatDoc == null
                    ? Expanded(child: Container())
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: chatDoc.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    user.uid == chatDoc[index]['senderID']
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: user.uid ==
                                                chatDoc[index]['senderID']
                                            ? const Radius.circular(0)
                                            : const Radius.circular(30),
                                        bottomLeft: user.uid ==
                                                chatDoc[index]['senderID']
                                            ? const Radius.circular(30)
                                            : const Radius.circular(0),
                                        topLeft: const Radius.circular(30),
                                        topRight: const Radius.circular(30),
                                      ),
                                      color:
                                          user.uid == chatDoc[index]['senderID']
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Text(
                                      chatDoc[index]['message'],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      filled: true,
                      suffixIcon: IconButton(
                        onPressed: _submit,
                        icon: const Icon(Icons.arrow_forward_ios_outlined),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
