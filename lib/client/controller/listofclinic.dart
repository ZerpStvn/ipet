import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipet/client/pages/clinicsingleview.dart';
import 'package:ipet/misc/function.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';

class DisplayListofClinic extends StatefulWidget {
  final AuthProviderClass provider;
  final double maxRadius;
  const DisplayListofClinic({
    super.key,
    required this.provider,
    required this.maxRadius,
  });

  @override
  State<DisplayListofClinic> createState() => _DisplayListofClinicState();
}

class _DisplayListofClinicState extends State<DisplayListofClinic> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 155,
      child: FutureBuilder(
        future: FirebaseFirestore.instance.collectionGroup('vertirenary').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            debugPrint('Error: ${snapshot.error}');
          }
          double userLat = double.parse("${widget.provider.usermapping!.lat}");

          double userLon = double.parse("${widget.provider.usermapping!.long}");
          List<DocumentSnapshot> vetDocuments = snapshot.data!.docs;
          List<DocumentSnapshot> nearbyVets = filterVetsByProximity(
              userLat, userLon, widget.maxRadius, vetDocuments);

          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: nearbyVets.length,
            itemBuilder: (BuildContext context, int index) {
              var vet = nearbyVets[index];
              List<dynamic> services = vet["services"];
              String vetID = vet.id;

              List<Widget> displayedServices = services
                  .sublist(0, services.length > 2 ? 2 : services.length)
                  .map<Widget>((service) {
                return Chip(
                  side: BorderSide(width: 1, color: maincolor),
                  backgroundColor: maincolor,
                  labelStyle: const TextStyle(color: Colors.white),
                  label: MainFont(
                    title: service.toString(),
                    fsize: 12,
                  ),
                );
              }).toList();
              if (vet['valid'] == 1) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ClinicViewSingle(documentID: vetID)));
                  },
                  child: SizedBox(
                      width: 310,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 9.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9.0, vertical: 2),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                "${vet["imageprofile"]}"))),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 140,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MainFont(title: "${vet["clinicname"]}"),
                                        MainFont(
                                            title:
                                                "Distance: ${calculateDistance(userLat, userLon, double.parse("${vet['lat']}"), double.parse("${vet['long']}")).toStringAsFixed(2)} km"),
                                        FutureBuilder<double>(
                                          future: calculateRating(vetID),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Container();
                                            } else if (snapshot.hasError ||
                                                !snapshot.hasData) {
                                              return MainFont(
                                                title: "No Reviews",
                                                color: maincolor,
                                              );
                                            } else {
                                              return MainFont(
                                                title:
                                                    "Reviews ${snapshot.data}",
                                                color: maincolor,
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Wrap(
                                spacing: 4.0,
                                runSpacing: 4.0,
                                children: displayedServices,
                              )
                            ],
                          ),
                        ),
                      )

                      // You can add more information or customize the ListTile as needed

                      ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}
