import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ipet/client/pages/service/notif.dart';
import 'package:ipet/controller/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  late SharedPreferences preferences;
  final user = FirebaseAuth.instance.currentUser;
  final NotificationService _notificationService = NotificationService();
  bool onboardsave = false;
  @override
  void initState() {
    super.initState();
    checkonboard();
    _listenToFirestoreNotifications();
  }

  Future<void> checkonboard() async {
    preferences = await SharedPreferences.getInstance();

    setState(() {
      onboardsave = preferences.getBool('onboard') ?? false;

      debugPrint("$onboardsave");
    });
  }

  /// Listens to Firestore Notifications collection
  void _listenToFirestoreNotifications() {
    FirebaseFirestore.instance
        .collection('notif')
        .doc(user!.uid)
        .collection('notif')
        .orderBy('ctreated', descending: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          String? title = data['type'];
          String? body = data['title'];

          _notificationService.showNotification(title: title, body: body);

          // Display the notification
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GloballoginController();
  }
}
