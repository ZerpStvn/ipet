import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> sendnotification(String userid, String title, String type) async {
  try {
    await FirebaseFirestore.instance
        .collection("notif")
        .doc(userid)
        .collection("notif")
        .add({
      "notif": userid,
      "title": title,
      "type": type,
      "ctreated": Timestamp.now(),
    });
  } catch (error) {
    debugPrint("$error");
  }
}
