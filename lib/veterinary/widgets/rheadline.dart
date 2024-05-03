import 'package:flutter/material.dart';
import 'package:ipet/misc/themestyle.dart';

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
          Text(
            "View More",
            style: TextStyle(color: maincolor, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
