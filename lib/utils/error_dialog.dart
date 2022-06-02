import 'package:flutter/material.dart';
import 'package:thunder_chat_app/models/custom_error.dart';

void errorDialog(BuildContext context, CustomError error) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(error.code),
          content: Text(error.plugin + '\n' + error.message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      });
}
