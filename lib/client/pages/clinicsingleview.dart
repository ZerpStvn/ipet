// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ipet/client/pages/chat.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
  Future<void> _sendMessage() async {
    try {
      List<String> ids = [widget.documentID, _auth.currentUser!.uid];
      ids.sort();
      String chatDocId = ids.join("_");
      DocumentReference chatDoc = _firestore.collection('chats').doc(chatDocId);

      // Create or update the chat document
      await chatDoc.set({
        'vetID': widget.documentID,
        'userid': _auth.currentUser!.uid,
      }, SetOptions(merge: true));

      CollectionReference messageCollection = chatDoc.collection('message');

      await messageCollection.add({
        'text': "New Scheduled Appointment",
        'senderId': _auth.currentUser!.uid,
        'vetId': widget.documentID,
        'imageUrl': null,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userauth = Provider.of<AuthProviderClass>(context);
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: maincolor,
          shape: BoxShape.circle,
        ),
        child: IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatVet(vetID: "${widget.documentID}"))),
            icon: Icon(
              Icons.message_outlined,
              color: Colors.white,
            )),
      ),
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
                        showoperationtimeavailable(
                            operations,
                            userauth,
                            "${data['imageprofile'] ?? ""}",
                            "${data['clinicname'] ?? ""}");
                        // _selectDateTime(
                        //     context,
                        //     userauth,
                        //     "${data['imageprofile'] ?? ""}",
                        //     "${data['clinicname'] ?? ""}");
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

  void showoperationtimeavailable(
    dynamic operations,
    AuthProviderClass userauth,
    String clinicprofile,
    String name,
  ) {
    int countdown = 3; // Start with 3 seconds
    bool isContinueEnabled = false;

    // Define a Timer variable
    Timer? countdownTimer;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Start the countdown timer only once
            if (countdownTimer == null) {
              countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                if (countdown > 1) {
                  countdown--;
                  if (mounted) {
                    setState(() {}); // Update the UI
                  }
                } else {
                  countdown = 0;
                  isContinueEnabled = true;
                  timer.cancel(); // Stop the timer
                  if (mounted) {
                    setState(() {}); // Final update to enable the button
                  }
                }
              });
            }

            return AlertDialog(
              title: Text("Operation Time"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...operations.map((e) {
                    return Text(
                        "${e['day']} ${e['startTime']} - ${e['endTime']} ");
                  }).toList(),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    countdownTimer
                        ?.cancel(); // Cancel the timer when dialog is closed
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: isContinueEnabled
                      ? () {
                          countdownTimer
                              ?.cancel(); // Cancel the timer when moving forward
                          _selectDateTime(
                            context,
                            userauth,
                            clinicprofile,
                            name,
                          );
                        }
                      : null,
                  child: countdown > 0
                      ? Text("Continue (${countdown})")
                      : Text("Continue"),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Ensure the timer is canceled if the dialog is closed unexpectedly
      countdownTimer?.cancel();
    });
  }

  Future<void> _selectDateTime(
    BuildContext context,
    AuthProviderClass auth,
    String clinicprofile,
    String name,
  ) async {
    try {
      // Fetch existing appointments
      final snapshot = await FirebaseFirestore.instance
          .collection('appointment')
          .doc(widget.documentID) // Assuming widget.documentID is defined
          .collection('vet')
          .get();
      debugPrint("Appointment $snapshot");

      // Parse the booked slots into a set of DateTimes
      final bookedSlots = snapshot.docs
          .map((doc) {
            final timestamp = doc['appoinmentdate'] as Timestamp?;
            return timestamp?.toDate();
          })
          .whereType<DateTime>()
          .toList();

      // Define a function to check if a date is selectable
      bool isSelectableDate(DateTime date) {
        // All dates are selectable, we don't disable dates
        return true;
      }

      // Adjust the initialDate to the next available date
      DateTime initialDate = _selectedDateTime ?? DateTime.now();

      // Show the date picker
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        selectableDayPredicate: isSelectableDate,
      );

      if (pickedDate != null) {
        // Filter out already booked times for the selected date
        final bookedTimes = bookedSlots
            .where((slot) =>
                slot.year == pickedDate.year &&
                slot.month == pickedDate.month &&
                slot.day == pickedDate.day)
            .map((slot) => TimeOfDay(hour: slot.hour, minute: slot.minute))
            .toList();

        // Generate available times (on the hour, every hour)
        final availableTimes = List.generate(24, (hour) {
          final time = TimeOfDay(hour: hour, minute: 0);
          // Check if this time or the next hour is booked
          final nextHour = TimeOfDay(hour: hour + 1, minute: 0);
          return !bookedTimes.contains(time) && !bookedTimes.contains(nextHour)
              ? time
              : null;
        }).whereType<TimeOfDay>().toList();

        // Ensure at least one time is available
        if (availableTimes.isNotEmpty) {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: false),
                child: child ?? SizedBox(),
              );
            },
          );

          if (pickedTime != null) {
            // Ensure the selected time starts on the hour
            final DateTime selectedTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              0, // Minute forced to 0
            );

            // Check if the selected time or the next hour is booked
            if (!bookedSlots.any((slot) =>
                slot.year == selectedTime.year &&
                slot.month == selectedTime.month &&
                slot.day == selectedTime.day &&
                (slot.hour == selectedTime.hour ||
                    slot.hour == selectedTime.hour + 1))) {
              setState(() {
                isuploading = true;
                _selectedDateTime = selectedTime;
              });

              // Call your showModalService or other actions
              showModalService(auth, clinicprofile, name);

              setState(() {
                isuploading = false;
              });
            } else {
              // Notify user the selected time is not available
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("The selected time is Already taken.")),
              );
              Navigator.pop(context);
            }
          }
        } else {
          // Notify user no times are available for the selected date
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("No available times for the selected date.")),
          );
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
        }).then((onvalue) {
          _sendMessage();
        });
        setState(() {});
      }
    } catch (error) {
      debugPrint("$error");
    }
  }
}
