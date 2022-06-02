import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thunder_chat_app/cubits/auth/auth_cubit.dart';
import 'package:thunder_chat_app/cubits/users/users_cubit.dart';
import 'package:thunder_chat_app/models/user_models.dart';
import 'package:thunder_chat_app/utils/error_dialog.dart';

import 'drawer_item.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    context.read<UsersCubit>().getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersCubit, UsersState>(
      listener: (context, state) {
        if (state.userStatus == UserStatus.error) {
          errorDialog(context, state.customError);
        }
      },
      builder: (context, state) {
        if (state.userStatus == UserStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.userStatus == UserStatus.loaded) {
          final List<UserModel> listOfUsers = state.usersList
              .where((user) =>
                  user.userID != context.read<AuthCubit>().state.user!.uid)
              .toList();
          return SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Avalabile Users',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: listOfUsers.length,
                  itemBuilder: (context, index) {
                    return DrawerItem(
                      index: index,
                      listOfUsers: listOfUsers,
                    );
                  },
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
