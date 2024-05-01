import 'package:flutter/material.dart';
import 'package:ipet/misc/themestyle.dart';

class TopBar extends StatelessWidget {
  final String clinicname;
  const TopBar({super.key, required this.clinicname});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Welcome and\nHave a great day",
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.25)),
            ]),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.location_on,
                size: 25,
                color: maincolor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
