import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thunder_chat_app/cubits/delete_chat/delete_chat_cubit.dart';
import 'package:thunder_chat_app/models/chat_model.dart';
import 'package:thunder_chat_app/pages/home_page.dart';
import 'package:thunder_chat_app/pages/splash_screen.dart';

import '../pages/chat_page.dart';

Widget chatWidget({
  required ChatModel chat,
  required BuildContext context,
  required String id,
  required String reciverID,
}) {
  return Column(
    children: [
      ListTile(
        onTap: () => Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  reciverEmail: chat.email,
                  reciverName: chat.name,
                  reciverID: chat.userID,
                  reciverImage: chat.imageUrl,
                ),
              ),
            )
            .then(
                (value) => Navigator.of(context).pushNamed(HomePage.routeName)),
        onLongPress: () {
          showDialog(
            context: context,
            builder: (_) {
              return BlocBuilder<DeleteChatCubit, DeleteChatState>(
                builder: (context, state) {
                  return AlertDialog(
                    title: Text('Delete Chat'),
                    content: Text('Do you want to delete this chat?'),
                    actions: [
                      TextButton(
                        onPressed: state.deleteChatStatus ==
                                DeleteChatStatus.deleting
                            ? null
                            : () async {
                                await context
                                    .read<DeleteChatCubit>()
                                    .deleteChat(id: id, reciverID: reciverID)
                                    .then(
                                      (_) => Navigator.pop(context),
                                    );
                              },
                        child:
                            state.deleteChatStatus == DeleteChatStatus.deleting
                                ? Text('Deleting...')
                                : Text('Delete'),
                      ),
                      TextButton(
                        onPressed:
                            state.deleteChatStatus == DeleteChatStatus.deleting
                                ? null
                                : () => Navigator.pop(context),
                        child: Text('Cancle'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        leading: CircleAvatar(
          backgroundImage: NetworkImage(chat.imageUrl),
        ),
        title: Text(chat.name),
        subtitle: Text(chat.lastMessage),
      ),
      Divider(thickness: 1),
    ],
  );
}
