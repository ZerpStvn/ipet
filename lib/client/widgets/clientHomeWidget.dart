// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ipet/client/controller/signlocation.dart';
import 'package:ipet/client/pages/main.client.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:ipet/utils/firebasehook.dart';

class ClientHomeWidget extends StatelessWidget {
  const ClientHomeWidget({
    super.key,
    required this.provider,
  });

  final AuthProviderClass provider;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: usercred
            .doc("${provider.userModel!.vetid}")
            .collection('client')
            .doc("${provider.userModel!.vetid}")
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LinearProgressIndicator(
                color: maincolor,
              ),
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const SignClientLocation();
          } else {
            return const ManClientPage();
          }
        });
  }
}
