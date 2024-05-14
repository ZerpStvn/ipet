import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipet/misc/themestyle.dart';

class RecentAppointment extends StatelessWidget {
  final bool istitle;
  const RecentAppointment({
    super.key,
    required this.istitle,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("userappointment")
            .orderBy('appoinmentdate', descending: true)
            .limit(1)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            debugPrint("error = ${snapshot.error}");
            return const MainFont(title: "No Appointment For Now ");
          } else if (snapshot.hasData) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: istitle == false ? 180 : 230,
              child: ListView.builder(
                  shrinkWrap: false,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var datafetch = snapshot.data!.docs.first.data();
                    Timestamp timestamp = datafetch['appoinmentdate'];
                    DateTime dateTime = timestamp.toDate();
                    String formattedDate =
                        DateFormat('MMMM dd, yyyy h:mm a').format(dateTime);
                    if (datafetch['status'] == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: istitle == true ? 30 : 0),
                          istitle == true
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
                                  )
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
}
