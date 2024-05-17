import 'package:flutter/material.dart';
import 'package:ipet/misc/themestyle.dart';

void handlenotcontinue(BuildContext context) {
  showDialog(
      context: (context),
      builder: (context) {
        return AlertDialog(
          title: MainFont(title: "Cancel"),
          content: (MainFont(
              title: "Are you sure you wan to cancel\nyour application?")),
        );
      });
}
