import 'package:flutter/material.dart';
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
                        //       userLat: double.parse("${userauth.usermapping!.lat}"),
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
                      subtitle: MainFont(
                        title: "Reviews 4.4",
                        color: maincolor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: operations.map((e) {
                              return Text(
                                  "${e['day']} ${e['startTime']} - ${e['endTime']}, ");
                            }).toList(),
                          ),
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
                          const Text("Rate our Service",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: maincolor,
                            ),
                            onRatingUpdate: (rating) {
                              debugPrint("${rating}");
                            },
                          )
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
}
