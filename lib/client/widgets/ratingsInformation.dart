// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipet/client/pages/clinicsingleview.dart';
import 'package:ipet/misc/function.dart';
import 'package:ipet/misc/themestyle.dart';

class RatingsDetails extends StatelessWidget {
  const RatingsDetails({
    super.key,
    required this.data,
    required this.widget,
    required this.viewrate,
  });

  final Map<String, dynamic>? data;
  final ClinicViewSingle widget;
  final Function viewrate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Container(
            height: 60,
            width: 80,
            decoration: BoxDecoration(
                color: const Color.fromARGB(80, 158, 158, 158),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage("${data!['imageprofile']}"))),
          ),
          title: MainFont(title: "${data!['clinicname']}"),
          subtitle: FutureBuilder<double>(
            future: calculateRating(widget.documentID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasError || !snapshot.hasData) {
                return MainFont(
                  title: "No Reviews",
                  color: maincolor,
                );
              } else {
                return MainFont(
                  title:
                      "Reviews ${double.parse("${snapshot.data}").toStringAsFixed(1)}",
                  color: maincolor,
                );
              }
            },
          ),
          trailing: TextButton(
              onPressed: () {
                viewrate();
              },
              child: const Text("Rate")),
        ),
        FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.documentID)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.hasError ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else {
                var datafield = snapshot.data!.data();
                return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_box_rounded,
                          color: datafield!['isverified'] == 1
                              ? Colors.green
                              : Colors.red,
                        ),
                        Text(datafield['isverified'] == 1
                            ? "Clinic Verified"
                            : "Clinic Is Not Verified")
                      ],
                    ));
              }
            })
      ],
    );
  }
}
