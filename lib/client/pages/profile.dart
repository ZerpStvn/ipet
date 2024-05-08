import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ipet/controller/login.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:ipet/utils/firebasehook.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientProfile extends StatefulWidget {
  const ClientProfile({super.key});

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  bool islogout = false;
  final useAuthlogout = FirebaseAuth.instance;
  late SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    final provder = Provider.of<AuthProviderClass>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 240,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: maincolor),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage("${provder.userModel!.imageprofile}"),
                  )),
              Expanded(
                  flex: 2,
                  child: ListTile(
                    subtitle: const Row(
                      children: [
                        Icon(
                          Icons.pets_outlined,
                          color: Colors.white,
                          size: 15,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        MainFont(
                            color: Colors.white, fsize: 15, title: "Pet Owner"),
                      ],
                    ),
                    title: MainFont(
                        color: Colors.white,
                        fsize: 23,
                        title:
                            "${provder.userModel!.fname} ${provder.userModel!.lname}"),
                  ))
            ],
          ),
        ),
        ListTile(
          onTap: () {
            islogout == true ? null : logout();
          },
          leading: const Icon(Icons.logout_outlined),
          title: const MainFont(title: "Logout"),
          trailing: islogout == true
              ? SizedBox(
                  width: 5,
                  height: 6,
                  child: CircularProgressIndicator(
                    color: maincolor,
                  ),
                )
              : const Text(""),
        )
      ],
    );
  }

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
}
