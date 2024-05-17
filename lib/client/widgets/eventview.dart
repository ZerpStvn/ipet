import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class EventViewFormat extends StatefulWidget {
  final bool istitle;
  final String vetid;
  final bool isadmin;
  const EventViewFormat({
    super.key,
    required this.istitle,
    required this.vetid,
    required this.isadmin,
  });

  @override
  State<EventViewFormat> createState() => _EventViewFormatState();
}

class _EventViewFormatState extends State<EventViewFormat> {
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
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection(
                    widget.isadmin == false ? "userappointment" : "appointment")
                .doc(porvider.userModel!.vetid)
                .collection(widget.isadmin == false ? 'user' : 'vet')
                .doc(widget.vetid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasError || !snapshot.hasData) {
                debugPrint("error = ${snapshot.error}");
                return const MainFont(title: "No Appointment For Now ");
              } else if (snapshot.hasData) {
                var datafetch = snapshot.data!.data();
                if (datafetch != null) {
                  Timestamp timestamp =
                      datafetch['appoinmentdate'] ?? Timestamp.now();
                  DateTime dateTime = timestamp.toDate();
                  String formattedDate =
                      DateFormat('MMMM dd, yyyy h:mm a').format(dateTime);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: widget.isadmin == false ? 210 : 160,
                        child: Column(
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
                            Padding(
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
                                                        "${widget.isadmin == false ? datafetch['vetprofile'] : datafetch['profile']}"))),
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
                                                      "${widget.isadmin == false ? datafetch['clinic'] : datafetch['name']}"),
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
                                  widget.isadmin == false
                                      ? updaterender(datafetch, widget.vetid)
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            widget.isadmin == false
                                ? Center(
                                    child: MainFont(
                                        align: TextAlign.center,
                                        title:
                                            "Please remember to arrive 30 minutes\nbefore your appointment."),
                                  )
                                : Container(),
                            TableCalendar(
                              firstDay: DateTime.utc(2010, 10, 16),
                              lastDay: DateTime.utc(2030, 3, 14),
                              focusedDay: DateTime.now(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            MainFont(
                              title: "Service",
                              fsize: 20,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Chip(
                              label: MainFont(
                                  color: Colors.white,
                                  title: "${datafetch['service']}"),
                              backgroundColor: maincolor,
                            ),
                            MainFont(
                              title: "Purpose ",
                              fsize: 20,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Chip(
                              label: MainFont(
                                  color: Colors.white,
                                  title: "${datafetch['purpose']}"),
                              backgroundColor: maincolor,
                            )
                          ],
                        ),
                      )
                    ],
                  );
                } else {
                  return const Center(
                      child: MainFont(title: "No Appointment For Now "));
                }
              } else {
                return Container();
              }
            }),
      ),
    );
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
