import 'package:flutter/material.dart';
import 'package:ipet/client/controller/gmapclient.dart';
import 'package:ipet/misc/themestyle.dart';

class SignClientLocation extends StatefulWidget {
  const SignClientLocation({super.key});

  @override
  State<SignClientLocation> createState() => _SignClientLocationState();
}

class _SignClientLocationState extends State<SignClientLocation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 40,
          ),
          child: Container(
            height: 250,
            width: 250,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage("assets/maps.jpeg"))),
          ),
        ),
        const SizedBox(
          height: 29,
        ),
        const Center(
            child: MainFont(
                align: TextAlign.center,
                fsize: 18,
                title: "Provide us your location for\nbetter experience")),
        const SizedBox(
          height: 29,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.50,
            child: GlobalButton(
                callback: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ClientMapController()));
                },
                title: "Continue"))
      ],
    );
  }
}
