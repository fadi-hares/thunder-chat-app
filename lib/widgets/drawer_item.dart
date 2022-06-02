import 'package:flutter/material.dart';

import 'package:thunder_chat_app/models/user_models.dart';
import 'package:thunder_chat_app/pages/home_page.dart';
import 'package:thunder_chat_app/pages/splash_screen.dart';

import '../pages/chat_page.dart';

class DrawerItem extends StatelessWidget {
  final List<UserModel> listOfUsers;
  final int index;
  const DrawerItem({
    Key? key,
    required this.listOfUsers,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                reciverName: listOfUsers[index].userName,
                reciverID: listOfUsers[index].userID,
                reciverImage: listOfUsers[index].userImage,
                reciverEmail: listOfUsers[index].userEmail,
              ),
            ),
          ).then((_) {
            Navigator.pushNamed(context, HomePage.routeName);
          }),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: Text(
              listOfUsers[index].userName,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            trailing: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                listOfUsers[index].userImage,
              ),
            ),
          ),
        ),
        const Divider(height: 20, thickness: 1),
      ],
    );
  }
}
