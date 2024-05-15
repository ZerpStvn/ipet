import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:provider/provider.dart';

class RecentAppointment extends StatefulWidget {
  final bool istitle;
  const RecentAppointment({
    super.key,
    required this.istitle,
  });

  @override
  State<RecentAppointment> createState() => _RecentAppointmentState();
}

class _RecentAppointmentState extends State<RecentAppointment> {
  List<Map<String, dynamic>> callback = [
    {
      "icon": Icons.delete_outlined,
      "title": "Delete",
      "function": "del",
    },
    {
      "icon": Icons.cancel_outlined,
      "title": "Cancel",
      "function": "cancel",
    },
    {
      "icon": Icons.done_outlined,
      "title": "Done",
      "function": "dn",
    }
  ];

  Future<void> updatecancel(String userid, String docs) async {
    try {
      await FirebaseFirestore.instance
          .collection("userappointment")
          .doc(userid)
          .collection('user')
          .doc(docs)
          .update({"status": 1});
      setState(() {});
    } catch (error) {
      debugPrint("$error");
    }
  }

  Future<void> updatedone(String userid, String docs) async {
    try {
      await FirebaseFirestore.instance
          .collection("userappointment")
          .doc(userid)
          .collection('user')
          .doc(docs)
          .update({"status": 2}).then((value) {
        setState(() {});
      });
    } catch (error) {
      debugPrint("$error");
    }
  }

  Future<void> updatedelete(String userid, String docs) async {
    try {
      await FirebaseFirestore.instance
          .collection("userappointment")
          .doc(userid)
          .collection('user')
          .doc(docs)
          .delete();
      setState(() {});
    } catch (error) {
      debugPrint("$error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final porvider = Provider.of<AuthProviderClass>(context);
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("userappointment")
            .doc(porvider.userModel!.vetid)
            .collection('user')
            .orderBy('appoinmentdate', descending: true)
            .limit(1)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError || !snapshot.hasData) {
            debugPrint("error = ${snapshot.error}");
            return const MainFont(title: "No Appointment For Now ");
          } else if (snapshot.data!.docs.isNotEmpty) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: widget.istitle == false ? 260 : 290,
              child: ListView.builder(
                  shrinkWrap: false,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var datafetch = snapshot.data!.docs.first.data();
                    DocumentSnapshot doc = snapshot.data!.docs.first;
                    var getid = doc.id;
                    Timestamp timestamp = datafetch['appoinmentdate'];
                    DateTime dateTime = timestamp.toDate();
                    String formattedDate =
                        DateFormat('MMMM dd, yyyy h:mm a').format(dateTime);
                    {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: widget.istitle == true ? 30 : 0),
                          widget.istitle == true
                              ? const MainFont(
                                  title: "Recent Appointment",
                                  fsize: 16,
                                )
                              : Container(),
                          const SizedBox(height: 10),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 110,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        "${datafetch['vetprofile']}"))),
                                          )),
                                      const SizedBox(
                                        width: 9,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Chip(
                                                  backgroundColor: maincolor,
                                                  side: BorderSide(
                                                      width: 1,
                                                      color: maincolor),
                                                  label: const MainFont(
                                                    color: Colors.white,
                                                    title: "Appoinment",
                                                    fsize: 9,
                                                  )),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              MainFont(
                                                  fsize: 15,
                                                  title:
                                                      "${datafetch['clinic']}"),
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              MainFont(
                                                title: formattedDate,
                                                fsize: 13,
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  updaterender(datafetch, getid),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
            );
          } else {
            return Container();
          }
        });
  }

  Widget updaterender(datafetch, String getid) {
    if (datafetch['status'] == 0) {
      debugPrint("datafetch = ${datafetch['status']}");
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: callback.map((e) {
          return Expanded(
            child: SizedBox(
              child: GestureDetector(
                onTap: () {
                  if (e['function'] == 'dn') {
                    updatedone("${datafetch['userid']}", getid);
                  } else if (e['function'] == "cancel") {
                    updatecancel("${datafetch['userid']}", getid);
                  } else if (e['function'] == 'del') {
                    updatedelete("${datafetch['userid']}", getid);
                  } else {
                    null;
                  }
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(e['icon']),
                        Text(e['title']),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    } else if (datafetch['status'] == 1) {
      debugPrint("datafetch = ${datafetch['status']}");
      return const MainFont(title: "Cancelled");
    } else if (datafetch['status'] == 2) {
      return const MainFont(title: "Done");
    } else {
      return Container();
    }
  }
}
