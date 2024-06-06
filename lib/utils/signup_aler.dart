import 'package:flutter/material.dart';
import 'package:ipet/misc/themestyle.dart';

void handlenotcontinue(BuildContext context, Function delete) {
  showDialog(
      context: (context),
      builder: (context) {
        return AlertDialog(
          title: MainFont(title: "Cancel"),
          content: (MainFont(
              title: "Are you sure you wan to cancel\nyour application?")),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No")),
            TextButton(
                onPressed: () {
                  delete();
                },
                child: Text("Yes")),
          ],
        );
      });
}

// Future deleteccount(String doid) async {
//   try {
//     await usercred.doc(doid).delete();
//   } catch (err) {
//     debugPrint("$err");
//   }
// }
