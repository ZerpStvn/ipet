import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/veterinary/pages/calendarvet.dart';

class SHeadline extends StatelessWidget {
  const SHeadline({super.key});

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
                "Check Your Canlendar",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                "view canlendar for appointment",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CalendarVet()));
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
