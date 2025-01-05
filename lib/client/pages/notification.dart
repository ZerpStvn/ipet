import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ipet/misc/themestyle.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final userid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            "Notifications",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("notif")
              .doc(userid)
              .collection("notif")
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error loading notifications"));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No notifications found"));
            }

            // If data exists
            return ListView.builder(
              padding: EdgeInsets.all(0),
              shrinkWrap:
                  true, // Prevents ListView from taking infinite space in Column
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index].data();
                return ListTile(
                  leading: Icon(Icons.notifications_outlined),
                  title: Text(data['title'] ?? 'No Title'),
                );
              },
            );
          },
        )
      ],
    );
  }
}
