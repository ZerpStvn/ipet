import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipet/client/pages/clinicsingleview.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/vetirinary.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({super.key});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  final TextEditingController search = TextEditingController();
  String onchangevalue = "";

  @override
  void dispose() {
    super.dispose();
    search.dispose();
  }

  List<String> postdataquery = [];

  void searchqueary(String query) {
    setState(() {
      postdataquery = query.split(' ');
    });
  }

  Future<double> calculateRating(String documentID) async {
    double totalRating = 0;
    int reviewCount = 0;
    CollectionReference ratingsCollection = FirebaseFirestore.instance
        .collection('ratings')
        .doc(documentID)
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              TextFormField(
                controller: search,
                onChanged: (value) {
                  setState(() {
                    searchqueary(value);
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  hintText: "What's The name of the Place?",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collectionGroup('vertirenary')
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LinearProgressIndicator(
                        color: maincolor,
                      );
                    } else {
                      final vet = snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final clinicData = vet[index];
                          final clinicId = vet[index].id;
                          VeterinaryModel veterinaryModel =
                              VeterinaryModel.getdocument(
                                  snapshot.data!.docs[index].data());
                          List<dynamic> services = clinicData["services"];
                          List<Widget> displayedServices = services
                              .sublist(
                                  0, services.length > 2 ? 2 : services.length)
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
                          List<String> queryingdata = [
                            '${veterinaryModel.clinicname}'
                          ];

                          for (var value in queryingdata) {
                            if (postdataquery.any((element) => value
                                .toLowerCase()
                                .contains(element.toLowerCase()))) {
                              if (clinicData['valid'] == 1) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClinicViewSingle(
                                                    documentID: clinicId)));
                                  },
                                  child: SizedBox(
                                      width: 310,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0, left: 9.0),
                                        child: Card(
                                          elevation: 10,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  "${clinicData["imageprofile"]}"))),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      width: 140,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          MainFont(
                                                              title:
                                                                  "${clinicData["clinicname"]}"),
                                                          FutureBuilder<double>(
                                                            future:
                                                                calculateRating(
                                                                    clinicId),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return Container();
                                                              } else if (snapshot
                                                                      .hasError ||
                                                                  !snapshot
                                                                      .hasData) {
                                                                return MainFont(
                                                                  title:
                                                                      "No Reviews",
                                                                  color:
                                                                      maincolor,
                                                                );
                                                              } else {
                                                                return MainFont(
                                                                  title:
                                                                      "Reviews ${snapshot.data}",
                                                                  color:
                                                                      maincolor,
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
                                        ),
                                      )

                                      // You can add more information or customize the ListTile as needed

                                      ),
                                );
                              }
                            }
                          }
                          return Container();
                        },
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
