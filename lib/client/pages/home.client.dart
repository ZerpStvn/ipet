import 'package:flutter/material.dart';
import 'package:ipet/client/controller/signlocation.dart';
import 'package:ipet/client/pages/main.client.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:ipet/utils/firebasehook.dart';
import 'package:provider/provider.dart';

class HomeClientMain extends StatefulWidget {
  const HomeClientMain({super.key});

  @override
  State<HomeClientMain> createState() => _HomeClientMainState();
}

class _HomeClientMainState extends State<HomeClientMain> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProviderClass>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 65,
            ),
            FutureBuilder(
                future: usercred
                    .doc("${provider.userModel!.vetid}")
                    .collection('client')
                    .doc("${provider.userModel!.vetid}")
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: maincolor,
                      ),
                    );
                  } else if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const SignClientLocation();
                  } else {
                    return const ManClientPage();
                  }
                })
          ],
        ),
      ),
    );
  }
}
