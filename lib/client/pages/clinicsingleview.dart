import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:ipet/utils/firebasehook.dart';
import 'package:provider/provider.dart';

class ClinicViewSingle extends StatefulWidget {
  final String documentID;
  const ClinicViewSingle({super.key, required this.documentID});

  @override
  State<ClinicViewSingle> createState() => _ClinicViewSingleState();
}

class _ClinicViewSingleState extends State<ClinicViewSingle> {
  final TextEditingController comments = TextEditingController();
  bool iscomminting = false;
  double ratereivew = 0;
  @override
  void dispose() {
    super.dispose();
    comments.dispose();
  }

  Future<void> getratings(
      String name, String impageprofile, double rates) async {
    setState(() {
      iscomminting = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('ratings')
          .doc(widget.documentID)
          .collection('reviews')
          .add({
        "name": name,
        "date": DateTime.now(),
        "imageprofile": impageprofile,
        "comment": comments.text,
        "rates": rates
      }).then((value) {
        setState(() {
          iscomminting = false;
        });
      });
    } catch (e) {
      setState(() {
        iscomminting = false;
      });
      debugPrint("$e");
    }
  }

  // "profile": "${userauth.userModel!.imageprofile}",
  // "name": "${userauth.userModel!.fname}",
  Future<double> calculateRating() async {
    double totalRating = 0;
    int reviewCount = 0;
    CollectionReference ratingsCollection = FirebaseFirestore.instance
        .collection('ratings')
        .doc(widget.documentID)
        .collection('reviews');

    QuerySnapshot querySnapshot = await ratingsCollection.get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      Map<String, dynamic>? documentdata =
          querySnapshot.docs[i].data() as Map<String, dynamic>?;
      double rating = documentdata!['rates'] ?? 0;
      totalRating += rating;
      reviewCount++;
    }

    double averageRating = reviewCount > 0 ? totalRating / reviewCount : 0;

    return averageRating;
  }

  @override
  Widget build(BuildContext context) {
    final userauth = Provider.of<AuthProviderClass>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: usercred
                .doc(widget.documentID)
                .collection('vertirenary')
                .doc(widget.documentID)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LinearProgressIndicator(
                  color: maincolor,
                );
              } else if (snapshot.hasData) {
                debugPrint("dodument = ${widget.documentID}");
                final data = snapshot.data!.data();

                List<dynamic> services = data!['services'] ?? [];
                List<dynamic> specialties = data['specialties'] ?? [];
                List<dynamic> operations = data["operation"];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        // SizedBox(
                        //     width: MediaQuery.of(context).size.width,
                        //     height: 300,
                        //     child: VetClinicUserClientPolyline(
                        //       userLat:
                        //           double.parse("${userauth.usermapping!.lat}"),
                        //       userLon:
                        //           double.parse("${userauth.usermapping!.long}"),
                        //       clinicLat: double.parse("${data!['lat']}"),
                        //       clinicLon: double.parse("${data['long']}"),
                        //       ispolyline: true,
                        //     )),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      "${data['imageprofile'] ?? ""}"))),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: Container(
                        height: 60,
                        width: 80,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(80, 158, 158, 158),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    NetworkImage("${data['imageprofile']}"))),
                      ),
                      title: MainFont(title: "${data['clinicname']}"),
                      subtitle: FutureBuilder<double>(
                        future: calculateRating(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          } else if (snapshot.hasError || !snapshot.hasData) {
                            return MainFont(
                              title: "No Reviews",
                              color: maincolor,
                            );
                          } else {
                            return MainFont(
                              title: "Reviews ${snapshot.data}",
                              color: maincolor,
                            );
                          }
                        },
                      ),
                      trailing: TextButton(
                          onPressed: () {
                            ratingmoddal("${userauth.userModel!.fname}",
                                "${userauth.userModel!.imageprofile}");
                          },
                          child: const Text("Rate")),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: maincolor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () {},
                              child: const Text(
                                "Schedule Appointment",
                                style: TextStyle(color: Colors.white),
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text("Operation Time",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: operations.map((e) {
                              return Text(
                                  "${e['day']} ${e['startTime']} - ${e['endTime']} ");
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text("About the Clinic",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("${data["description"]}"),
                          const SizedBox(
                            height: 25,
                          ),
                          const Text("Services",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: services.map((e) {
                              return Chip(
                                side: BorderSide(width: 0, color: maincolor),
                                label: Text(e),
                                backgroundColor: maincolor,
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Text("Specialties",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: specialties.map((e) {
                              return Chip(
                                side: BorderSide(width: 0, color: maincolor),
                                label: Text(e),
                                backgroundColor: maincolor,
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('ratings')
                                  .doc(widget.documentID)
                                  .collection('reviews')
                                  .orderBy("date", descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
                                } else if (!snapshot.hasData ||
                                    snapshot.hasError) {
                                  return Container();
                                } else {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const MainFont(
                                        title: "Reviews and comments",
                                        fsize: 15,
                                        fweight: FontWeight.normal,
                                      ),
                                      ListView.builder(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            var datafetch = snapshot
                                                .data!.docs[index]
                                                .data();

                                            return ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    "${datafetch["imageprofile"]}"),
                                              ),
                                              title: MainFont(
                                                  title:
                                                      "${datafetch["name"]}"),
                                              subtitle: MainFont(
                                                  title:
                                                      " ${datafetch['comment']}"),
                                              trailing: MainFont(
                                                  title:
                                                      "${datafetch['rates']}"),
                                            );
                                          })
                                    ],
                                  );
                                }
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  void ratingmoddal(String name, String impageprofiles) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const MainFont(
                title: "Leave us a review",
                fweight: FontWeight.normal,
              ),
              actions: [
                iscomminting == false
                    ? TextButton(
                        onPressed: () {
                          iscomminting == false
                              ? getratings(name, impageprofiles, ratereivew)
                                  .then((value) => Navigator.pop(context))
                              : null;
                        },
                        child: const MainFont(title: "Submit"))
                    : CircularProgressIndicator(
                        color: maincolor,
                      ),
              ],
              content: SizedBox(
                height: 190,
                child: Column(
                  children: [
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: maincolor,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          ratereivew = rating;
                          debugPrint("$ratereivew");
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: comments,
                      maxLength: 340,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      decoration: const InputDecoration(
                          hintText: "Comments", border: OutlineInputBorder()),
                    )
                  ],
                ),
              ));
        });
  }
}
