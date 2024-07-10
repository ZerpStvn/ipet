// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ipet/client/widgets/ratingsInformation.dart';
import 'package:ipet/client/widgets/ratingsreview.dart';
import 'package:ipet/client/widgets/singlevetData.dart';
import 'package:ipet/controller/map/polyline.dart';
import 'package:ipet/misc/function.dart';
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
  final TextEditingController purpose = TextEditingController();
  List<String> services = [];
  bool iscomminting = false;
  double ratereivew = 0;
  double staffrate = 0;
  double pricrrate = 0;
  DateTime? _selectedDateTime;
  String? selectedValue;
  String? selectedaccomodation;
  bool isuploading = false;
  @override
  void initState() {
    super.initState();
    getlistofservices();
  }

  @override
  void dispose() {
    super.dispose();
    purpose.dispose();
    comments.dispose();
  }

  Future<void> getratings(
      String name, String impageprofile, double rates, String userid) async {
    setState(() {
      iscomminting = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('ratings')
          .doc(widget.documentID)
          .collection('reviews')
          .doc(userid)
          .set({
        "name": name,
        "date": DateTime.now(),
        "imageprofile": impageprofile,
        "comment": comments.text,
        "pricerate": pricrrate,
        "accomodation": selectedaccomodation,
        "staffrate": staffrate,
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
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            child: VetClinicUserClientPolyline(
                              userLat:
                                  double.parse("${userauth.usermapping!.lat}"),
                              userLon:
                                  double.parse("${userauth.usermapping!.long}"),
                              clinicLat: double.parse("${data['lat']}"),
                              clinicLon: double.parse("${data['long']}"),
                              ispolyline: true,
                            )),

                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   height: 300,
                        //   decoration: BoxDecoration(
                        //       image: DecorationImage(
                        //           fit: BoxFit.cover,
                        //           image: NetworkImage(
                        //               "${data['imageprofile'] ?? ""}"))),
                        // )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RatingsDetails(
                      data: data,
                      widget: widget,
                      viewrate: () {
                        ratingmoddal(
                            "${userauth.userModel!.fname}",
                            "${userauth.userModel!.imageprofile}",
                            "${userauth.userModel!.vetid}");
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleVetData(
                      operations: operations,
                      data: data,
                      services: services,
                      specialties: specialties,
                      widget: widget,
                      showmod: () {
                        _selectDateTime(
                            context,
                            userauth,
                            "${data['imageprofile'] ?? ""}",
                            "${data['clinicname'] ?? ""}");
                      },
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

  void ratingmoddal(String name, String impageprofiles, String userid) {
    showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: AlertDialog(
                title: const MainFont(
                  title: "Give us Feedback",
                  fweight: FontWeight.normal,
                ),
                actions: [
                  iscomminting == false
                      ? TextButton(
                          onPressed: () {
                            iscomminting == false
                                ? getratings(name, impageprofiles, ratereivew,
                                        userid)
                                    .then((value) => Navigator.pop(context))
                                : null;
                          },
                          child: const MainFont(title: "Submit"))
                      : CircularProgressIndicator(
                          color: maincolor,
                        ),
                ],
                content: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Ratingsreview(
                        ratings: (rating) {
                          setState(() {
                            ratereivew = rating;
                            debugPrint("$rating");
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
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const MainFont(title: "Rate our Staff"),
                      const SizedBox(
                        height: 10,
                      ),
                      Ratingsreview(ratings: (ratings) {
                        setState(() {
                          staffrate = ratings;
                          debugPrint("staff= $staffrate");
                        });
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      const MainFont(title: "Accomodation"),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButtonFormField<String>(
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          hint: const Text('Accomodotion Feedback'),
                          value: selectedaccomodation,
                          items: accomodation
                              .map((e) => DropdownMenuItem(
                                  value: e, child: MainFont(title: e)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedaccomodation = value;
                              debugPrint("$selectedaccomodation");
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Rate our accomodation' : null,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const MainFont(title: "Price "),
                      const SizedBox(
                        height: 10,
                      ),
                      Ratingsreview(ratings: (ratings) {
                        setState(() {
                          pricrrate = ratings;
                          debugPrint("$ratings");
                        });
                      }),
                    ],
                  ),
                )),
          );
        });
  }

  Future<void> _selectDateTime(
    BuildContext context,
    AuthProviderClass auth,
    String clinicprofile,
    String name,
  ) async {
    try {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDateTime ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );

      if (pickedDate != null) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          setState(() {
            isuploading = true;
          });

          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          showModalService(auth, clinicprofile, name);

          setState(() {
            isuploading = false;
          });
        }
      }
    } catch (error) {
      debugPrint("Error selecting date and time: $error");
      setState(() {
        isuploading = false;
      });
    }
  }

  Future<void> getlistofservices() async {
    try {
      DocumentSnapshot listofservice = await usercred
          .doc(widget.documentID)
          .collection("vertirenary")
          .doc(widget.documentID)
          .get();

      if (listofservice.exists) {
        Map<String, dynamic>? fetchdata =
            listofservice.data() as Map<String, dynamic>?;

        if (fetchdata != null && fetchdata.containsKey('services')) {
          List<dynamic> fetchedServices = fetchdata['services'];

          setState(() {
            services = List<String>.from(fetchedServices);
          });

          debugPrint("service = $services");
        }
      }
    } catch (e) {
      debugPrint("Error fetching services: $e");
    }
  }

  final _formKey = GlobalKey<FormState>();
  String get formattedDate {
    if (_selectedDateTime == null) {
      return 'No date selected';
    } else {
      return DateFormat('MMMM dd, yyyy').format(_selectedDateTime!);
    }
  }

  void showModalService(
      AuthProviderClass auth, String clinicprofile, String name) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Purpose of your appointment"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("You scheduled: $formattedDate"),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    hint: const Text('Service'),
                    value: selectedValue,
                    items: services
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a service' : null,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: purpose,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Purpose',
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a purpose'
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  updloadlisofapoinments(auth, clinicprofile, name)
                      .then((value) {
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  });
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updloadlisofapoinments(
      AuthProviderClass auth, String clinicprofile, String name) async {
    try {
      if (_formKey.currentState!.validate()) {
        await FirebaseFirestore.instance
            .collection('appointment')
            .doc(widget.documentID)
            .collection('vet')
            .add({
          'appoinmentdate': _selectedDateTime,
          'name': "${auth.userModel!.fname} ${auth.userModel!.lname} ",
          'profile': auth.userModel!.imageprofile,
          'userid': auth.userModel!.vetid,
          'vetprofile': clinicprofile,
          'clinic': name,
          'clinicid': widget.documentID,
          'status': 0,
          'purpose': purpose.text,
          'service': selectedValue,
        });
        await FirebaseFirestore.instance
            .collection('userappointment')
            .doc(auth.userModel!.vetid)
            .collection('user')
            .add({
          'appoinmentdate': _selectedDateTime,
          'name': "${auth.userModel!.fname} ${auth.userModel!.lname} ",
          'profile': auth.userModel!.imageprofile,
          'userid': auth.userModel!.vetid,
          'vetprofile': clinicprofile,
          'clinic': name,
          'clinicid': widget.documentID,
          'status': 0,
          'purpose': purpose.text,
          'service': selectedValue,
        });
        setState(() {});
      }
    } catch (error) {
      debugPrint("$error");
    }
  }
}
