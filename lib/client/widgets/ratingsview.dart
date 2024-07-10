import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipet/client/pages/clinicsingleview.dart';
import 'package:ipet/misc/themestyle.dart';

class RatingsView extends StatelessWidget {
  const RatingsView({
    super.key,
    this.widget,
    this.adminprofile,
    required this.isadmin,
  });

  final ClinicViewSingle? widget;
  final bool isadmin;
  final String? adminprofile;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ratings')
            .doc(isadmin == false ? widget!.documentID : adminprofile)
            .collection('reviews')
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (!snapshot.hasData || snapshot.hasError) {
            return Container();
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MainFont(
                  title: "Feedbacks",
                  fsize: 15,
                  fweight: FontWeight.normal,
                ),
                ListView.builder(
                    padding: const EdgeInsets.only(top: 5),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var datafetch = snapshot.data!.docs[index].data();
                      if (datafetch['comment'] != null) {
                        return Card(
                            child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "${datafetch["imageprofile"]}"),
                                ),
                                title: MainFont(title: "${datafetch["name"]}"),
                                subtitle:
                                    MainFont(title: " ${datafetch['comment']}"),
                                trailing:
                                    MainFont(title: "${datafetch['rates']}"),
                              ),
                              Wrap(
                                spacing: 4.0,
                                runSpacing: 4.0,
                                children: [
                                  Chip(
                                      backgroundColor: maincolor,
                                      side: BorderSide(
                                          width: 0, color: maincolor),
                                      label: MainFont(
                                          fsize: 14,
                                          color: Colors.white,
                                          title:
                                              "Pricing ${datafetch['pricerate']}")),
                                  Chip(
                                      backgroundColor: maincolor,
                                      side: BorderSide(
                                          width: 0, color: maincolor),
                                      label: MainFont(
                                          fsize: 14,
                                          color: Colors.white,
                                          title:
                                              "Staff ${datafetch['staffrate']}")),
                                  Chip(
                                      backgroundColor: maincolor,
                                      side: BorderSide(
                                          width: 0, color: maincolor),
                                      label: MainFont(
                                          fsize: 14,
                                          color: Colors.white,
                                          title:
                                              "${datafetch['accomodation']}")),
                                ],
                              ),
                            ],
                          ),
                        ));
                      } else {
                        return Container();
                      }
                    })
              ],
            );
          }
        });
  }
}
