import 'package:flutter/material.dart';
import 'package:ipet/controller/login.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/utils/firebasehook.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  late SharedPreferences prefs;
  bool islogout = false;
  Future<void> logout() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      islogout = true;
    });

    await userAuth.signOut().then((value) {
      prefs.remove("useremail");
      prefs.remove("userpsswowrd");
      setState(() {
        islogout = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const GloballoginController()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<AuthProviderClass>(context);
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
            child: GestureDetector(
              onTap: () {
                islogout == false ? logout() : null;
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.logout_outlined,
                  size: 25,
                  color: maincolor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
