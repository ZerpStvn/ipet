import 'package:flutter/material.dart';
import 'package:ipet/misc/themestyle.dart';

class SelectTypeUser extends StatefulWidget {
  const SelectTypeUser({
    super.key,
  });

  @override
  State<SelectTypeUser> createState() => _SelectTypeUserState();
}

class _SelectTypeUserState extends State<SelectTypeUser> {
  List<Map<String, dynamic>> selecttypeuser = [
    {
      "assets": "assets/fur.png",
      "isvet": false,
      "types": "Pet Owner",
      "route": "/pet"
    },
    {
      "assets": "assets/vet.png",
      "isvet": true,
      "types": "Veterinary",
      "route": "/vet"
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(
                //   height: 95,
                // ),
                Text(
                  "Choose Your User Type and Sign Up!",
                  style: TextStyle(
                      fontSize: 25,
                      color: maincolor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 5,
                  width: 70,
                  decoration: BoxDecoration(
                      color: maincolor, borderRadius: BorderRadius.circular(9)),
                ),
                const SizedBox(
                  height: 35,
                ),
                const Text(
                  "Welcome to our platform! We're excited to have you join us. Before you sign up, please select the user type that best fits your needs.",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
          Row(
            children: selecttypeuser.map((items) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, items['route']);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             SignupController(isvet: items['isvet'])));
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        width: 180,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.black),
                            image: DecorationImage(
                                image: AssetImage("${items['assets']}"))),
                      ),
                      Text("${items['types']}")
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
