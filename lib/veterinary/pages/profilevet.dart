import 'package:flutter/material.dart';
import 'package:ipet/misc/function.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:ipet/utils/firebasehook.dart';
import 'package:provider/provider.dart';

class VeterinaryProfile extends StatefulWidget {
  const VeterinaryProfile({super.key});

  @override
  State<VeterinaryProfile> createState() => _VeterinaryProfileState();
}

class _VeterinaryProfileState extends State<VeterinaryProfile> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProviderClass>(context);
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image:
                            NetworkImage("${provider.userModel!.imageprofile}"),
                        fit: BoxFit.cover)),
              )),
              Expanded(
                  flex: 2,
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainFont(
                          title: splitWords(
                              "${provider.userModel!.nameclinic}sdsafagfaghgththykju"),
                          fsize: 21,
                        ),
                        const Row(
                          children: [
                            Icon(Icons.domain_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            MainFont(title: "Veterinary Clinic")
                          ],
                        ),
                        provider.veterinarymovel!.valid == 1
                            ? const Row(
                                children: [
                                  Icon(
                                    Icons.check_rounded,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  MainFont(
                                    title: "Verified",
                                    color: Colors.green,
                                  )
                                ],
                              )
                            : const Row(
                                children: [
                                  Icon(
                                    Icons.pending,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  MainFont(
                                    title: "Reviewing",
                                    color: Colors.red,
                                  )
                                ],
                              )
                      ],
                    ),
                  ))
            ],
          ),
          // services
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: MainFont(
              title: "Phone number: ${provider.userModel!.pnum}",
              fsize: 15,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: MainFont(
              title: "Email: ${provider.userModel!.email}",
              fsize: 15,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: MainFont(
              title: "About us",
              fsize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              "${provider.veterinarymovel!.description}",
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: MainFont(
              title: "Services",
              fsize: 20,
            ),
          ),
          FutureBuilder(
            future: usercred
                .doc("${provider.userModel!.vetid}")
                .collection('vertirenary')
                .doc("${provider.userModel!.vetid}")
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasData) {
                List<String> services = [];
                if (snapshot.data!.exists) {
                  services = List<String>.from(
                      snapshot.data!.data()!['services'] ?? []);
                }
                return Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: services.map((e) {
                    return Chip(
                      side: BorderSide(width: 1, color: maincolor),
                      label: Text(e),
                      backgroundColor: maincolor,
                      labelStyle: const TextStyle(color: Colors.white),
                    );
                  }).toList(),
                );
              }
              return Container();
            },
          ),

          const Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: MainFont(
              title: "Specialties",
              fsize: 20,
            ),
          ),
          FutureBuilder(
            future: usercred
                .doc("${provider.userModel!.vetid}")
                .collection('vertirenary')
                .doc("${provider.userModel!.vetid}")
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasData) {
                List<String> services = [];
                if (snapshot.data!.exists) {
                  services = List<String>.from(
                      snapshot.data!.data()!['specialties'] ?? []);
                }
                return Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: services.map((e) {
                    return Chip(
                      label: Text(e),
                      backgroundColor: maincolor,
                      labelStyle: const TextStyle(color: Colors.white),
                    );
                  }).toList(),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
