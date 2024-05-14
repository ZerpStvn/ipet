// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ipet/client/pages/clinicsingleview.dart';
import 'package:ipet/client/widgets/ratingsview.dart';
import 'package:ipet/client/widgets/recentappointment.dart';
import 'package:ipet/misc/themestyle.dart';

class SingleVetData extends StatelessWidget {
  const SingleVetData({
    super.key,
    required this.operations,
    required this.data,
    required this.services,
    required this.specialties,
    required this.widget,
    required this.showmod,
  });

  final Function showmod;
  final List operations;
  final Map<String, dynamic>? data;
  final List services;
  final List specialties;
  final ClinicViewSingle widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: maincolor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                showmod();
              },
              child: const Text(
                "Schedule Appointment",
                style: TextStyle(color: Colors.white),
              )),
          const SizedBox(
            height: 15,
          ),
          const Text("Operation Time",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: operations.map((e) {
              return Text("${e['day']} ${e['startTime']} - ${e['endTime']} ");
            }).toList(),
          ),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.all(11.0),
            child: RecentAppointment(
              istitle: false,
            ),
          ),
          const Text("About the Clinic",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Text("${data!["description"]}"),
          const SizedBox(
            height: 25,
          ),
          const Text("Services",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: services.map((e) {
              return Chip(
                side: BorderSide(width: 0, color: maincolor),
                label: Text(e),
                backgroundColor: maincolor,
                labelStyle: const TextStyle(color: Colors.white),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 25,
          ),
          const Text("Specialties",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: specialties.map((e) {
              return Chip(
                side: BorderSide(width: 0, color: maincolor),
                label: Text(e),
                backgroundColor: maincolor,
                labelStyle: const TextStyle(color: Colors.white),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 25,
          ),
          RatingsView(widget: widget),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
