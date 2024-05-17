import 'package:flutter/material.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/veterinary/pages/vetsecheduled.dart';

class Headline extends StatelessWidget {
  const Headline({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Scheduled\nAppointments",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                "view your appointment",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VetScheduledAppointments()));
            },
            child: Text(
              "View More",
              style: TextStyle(color: maincolor, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
