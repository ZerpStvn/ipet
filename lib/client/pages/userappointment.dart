import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipet/client/widgets/recentappointment.dart';
import 'package:ipet/misc/function.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:provider/provider.dart';

class UserAppointmentcheck extends StatefulWidget {
  const UserAppointmentcheck({super.key});

  @override
  State<UserAppointmentcheck> createState() => _UserAppointmentcheckState();
}

class _UserAppointmentcheckState extends State<UserAppointmentcheck> {
  List<Map<String, dynamic>> callback = [
    {
      "icon": Icons.delete_outlined,
      "title": "Delete",
      "function": "del",
    },
    {
      "icon": Icons.cancel_outlined,
      "title": "Cancel",
      "function": "cancel",
    },
    {
      "icon": Icons.done_outlined,
      "title": "Done",
      "function": "dn",
    }
  ];
  List<Map<String, dynamic>> data = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      if (mounted) {
        final provider = Provider.of<AuthProviderClass>(context);
        final snapshot = await FirebaseFirestore.instance
            .collection('userappointment')
            .doc("${provider.userModel!.vetid}")
            .collection('user')
            .get();
        final List<Map<String, dynamic>> fetchedData =
            snapshot.docs.map((doc) => doc.data()).toList();
        setState(() {
          data = fetchedData;
        });
      }
    } catch (error) {
      debugPrint("$error");
    }
  }

  @override
  Widget build(BuildContext context) {
    ;
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          const RecentAppointment(
            istitle: true,
          ),
          DataTable(
            columns: const [
              DataColumn(
                  label: MainFont(
                title: "Appoint..",
              )),
              DataColumn(
                  label: MainFont(
                title: "Date",
              )),
              DataColumn(
                  label: MainFont(
                title: "status",
              )),
            ],
            rows: data.map((item) {
              Timestamp timestamp = item['appoinmentdate'];
              DateTime dateTime = timestamp.toDate();
              String formattedDate = DateFormat('EEE, M/d/y').format(dateTime);
              return DataRow(cells: [
                DataCell(MainFont(
                    title: truncateWithEllipsis(7, "${item['clinic']}"))),
                DataCell(MainFont(title: formattedDate)),
                DataCell(MainFont(
                    title: item['status'] == 0
                        ? "active"
                        : item['status'] == 1
                            ? "cancel"
                            : "Done"))
              ]);
            }).toList(),
          )
        ],
      ),
    );
  }
}
