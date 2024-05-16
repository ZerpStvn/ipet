import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipet/misc/function.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:provider/provider.dart';

class VetScheduledAppointments extends StatefulWidget {
  const VetScheduledAppointments({super.key});

  @override
  State<VetScheduledAppointments> createState() =>
      _VetScheduledAppointmentsState();
}

class _VetScheduledAppointmentsState extends State<VetScheduledAppointments> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProviderClass>(context);
    return Scaffold(
      appBar: AppBar(
        title: MainFont(
            title:
                truncateWithEllipsis(10, "${provider.userModel!.nameclinic}")),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('appointment')
                .doc(provider.userModel!.vetid)
                .collection('vet')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LinearProgressIndicator(
                  color: maincolor,
                );
              } else if (!snapshot.hasData) {
                return const Center(
                  child: MainFont(title: "No Recent Appointmenr"),
                );
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      var datafetch = snapshot.data!.docs[index].data();
                      Timestamp timestamp =
                          datafetch['appoinmentdate'] ?? Timestamp.now();
                      DateTime dateTime = timestamp.toDate();
                      String formattedDate =
                          DateFormat('MMMM dd, yyyy h:mm a').format(dateTime);
                      return ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        title: MainFont(title: "${datafetch['name']}"),
                        subtitle: MainFont(title: formattedDate),
                        leading: Container(
                          height: 70,
                          width: 69,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      NetworkImage("${datafetch['profile']}")),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    }));
              }
            }),
      ),
    );
  }
}
