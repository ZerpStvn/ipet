import 'package:flutter/material.dart';
import 'package:ipet/misc/themestyle.dart';

class MainPageAdmin extends StatefulWidget {
  const MainPageAdmin({
    super.key,
  });

  @override
  State<MainPageAdmin> createState() => _MainPageAdminState();
}

class _MainPageAdminState extends State<MainPageAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: maincolor,
        title: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: MainFont(
            title: "Veterinary Medical Clinic",
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: DrawerButton(),
          )
        ],
      ),
      body: const SingleChildScrollView(
          child: Column(
        children: [],
      )),
    );
  }
}
