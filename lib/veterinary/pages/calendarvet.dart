import 'package:flutter/material.dart';
import 'package:ipet/client/pages/userappointment.dart';
import 'package:ipet/misc/themestyle.dart';

class CalendarVet extends StatefulWidget {
  const CalendarVet({super.key});

  @override
  State<CalendarVet> createState() => _CalendarVetState();
}

class _CalendarVetState extends State<CalendarVet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MainFont(title: "Calendar"),
      ),
      body: const SingleChildScrollView(
        child: UserAppointmentcheck(isvetadmin: true),
      ),
    );
  }
}
