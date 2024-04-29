import 'package:flutter/material.dart';
import 'package:ipet/client/onboard.dart';
import 'package:ipet/controller/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  late SharedPreferences preferences;
  bool onboardsave = false;
  @override
  void initState() {
    super.initState();
    checkonboard();
  }

  Future<void> checkonboard() async {
    preferences = await SharedPreferences.getInstance();

    setState(() {
      onboardsave = preferences.getBool('onboard')!;

      debugPrint("$onboardsave");
    });
  }

  @override
  Widget build(BuildContext context) {
    return onboardsave == false
        ? const OnboardingPage()
        : const GloballoginController();
  }
}
