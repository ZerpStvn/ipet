import 'package:flutter/material.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';

class TopProfile extends StatelessWidget {
  const TopProfile({
    super.key,
    required this.provider,
  });

  final AuthProviderClass provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            flex: 2,
            child: MainFont(
              fsize: 24,
              fweight: FontWeight.bold,
              title: "Lets Find Clinic For\nYour Pet",
            )),
        Expanded(
            child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage("${provider.userModel!.imageprofile}"))),
        ))
      ],
    );
  }
}
