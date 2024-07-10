import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipet/client/widgets/eventview.dart';
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
                child: MainFont(title: "No Recent Appointment"),
              );
            } else {
              var appointments = snapshot.data!.docs;
              Map<String, List<Map<String, dynamic>>> groupedData = {};

              // Grouping appointments by date and including vetid
              for (var doc in appointments) {
                var vetid = doc.id;
                var data = doc.data();
                Timestamp timestamp = data['appoinmentdate'] ?? Timestamp.now();
                DateTime dateTime = timestamp.toDate();
                String formattedDate =
                    DateFormat('MMMM dd, yyyy').format(dateTime);

                var appointmentWithVetId = {
                  ...data,
                  'vetid': vetid,
                };

                if (groupedData[formattedDate] == null) {
                  groupedData[formattedDate] = [];
                }
                groupedData[formattedDate]!.add(appointmentWithVetId);
              }

              // Creating the list of widgets to display
              List<Widget> appointmentWidgets = [];
              groupedData.forEach((date, appointments) {
                appointmentWidgets.add(Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: MainFont(title: date),
                ));
                appointments.forEach((appointment) {
                  Timestamp timestamp =
                      appointment['appoinmentdate'] ?? Timestamp.now();
                  DateTime dateTime = timestamp.toDate();
                  String formattedTime = DateFormat('h:mm a').format(dateTime);
                  appointmentWidgets.add(ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventViewFormat(
                                    istitle: false,
                                    vetid: appointment['vetid'],
                                    isadmin: true,
                                  )));
                    },
                    contentPadding: const EdgeInsets.all(10),
                    title: MainFont(title: "${appointment['name']}"),
                    subtitle: MainFont(title: formattedTime),
                    leading: Container(
                      height: 70,
                      width: 69,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage("${appointment['profile']}")),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    trailing: MainFont(
                        title:
                            "Vet ID: ${truncateWithEllipsis(4, appointment['vetid'])}"),
                  ));
                });
              });

              return Padding(
                padding: const EdgeInsets.all(11.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: appointmentWidgets,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
