import 'package:flutter/material.dart';
import 'package:ipet/client/pages/userappointment.dart';
import 'package:ipet/misc/themestyle.dart';

class AppointmentVet extends StatelessWidget {
  const AppointmentVet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          MainFont(
            title: "Appointments",
            fsize: 23,
          ),
          UserAppointmentcheck(
            isvetadmin: true,
          ),
        ],
      ),
    );
  }
}
