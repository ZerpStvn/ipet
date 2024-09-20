// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<String> services = [];
  bool iscomminting = false;
  double ratereivew = 0;
  double staffrate = 0;
  double pricrrate = 0;
  DateTime? _selectedDateTime;
  String? selectedValue;
  String? selectedTimeSlot;
  List<String> availableTimeSlots = [];
  String? selectedaccomodation;
  bool isuploading = false;
  @override
  void initState() {
    super.initState();
    getlistofservices();
    debugPrint(widget.documentID);
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
              builder: (context) => ChatVet(vetID: widget.documentID),
            ),
          ),
          icon: const Icon(
            Icons.message_outlined,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.documentID)
              .collection('vertirenary')
              .doc(widget.documentID)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            } else if (snapshot.hasData && snapshot.data != null) {
              final data = snapshot.data!.data() as Map<String, dynamic>?;

              if (data == null) return const Text("No data found");

              List<dynamic> services = data['services'] ?? [];
              List<dynamic> specialties = data['specialties'] ?? [];
              List<dynamic> operations = data["operation"] ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: VetClinicUserClientPolyline(
                          userLat: double.parse("${userauth.usermapping!.lat}"),
                          userLon:
                              double.parse("${userauth.usermapping!.long}"),
                          clinicLat: double.parse("${data['lat']}"),
                          clinicLon: double.parse("${data['long']}"),
                          ispolyline: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RatingsDetails(
                    data: data,
                    widget: widget,
                    viewrate: () {
                      ratingmoddal(
                        "${userauth.userModel!.fname}",
                        "${userauth.userModel!.imageprofile}",
                        "${userauth.userModel!.vetid}",
                      );
                    },
                  ),
                  const SizedBox(height: 10),
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
                        "${data['clinicname'] ?? ""}",
                        operations, // Pass the operation times
                      );
                    },
                  ),
                ],
              );
            } else {
              return const Text('Error loading clinic data');
            }
          },
        ),
      ),
    );
  }

  Future<void> _selectDateTime(
    BuildContext context,
    AuthProviderClass auth,
    String clinicprofile,
    String name,
    List<dynamic> operations, // Operation times
  ) async {
    try {
      // Show date picker for the user to select a date
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDateTime ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );

      if (pickedDate != null) {
        // Assign the selected date to the state variable
        setState(() {
          _selectedDateTime = pickedDate;
        });

        // Extract the day of the week (e.g., "Tuesday")
        String selectedDay = DateFormat('EEEE').format(pickedDate);

        // Filter available time slots for the selected day
        List<Map<String, dynamic>> availableTimeSlotsForDay = operations
            .where((operation) => operation['day'] == selectedDay)
            .map((operation) {
          return {
            "startTime": operation['startTime'],
            "endTime": operation['endTime'],
          };
        }).toList();

        // Generate hourly time slots for the selected day
        List<String> hourlyTimeSlots =
            _generateTimeSlots(availableTimeSlotsForDay, pickedDate);

        if (hourlyTimeSlots.isNotEmpty) {
          // Remove duplicates, just in case
          hourlyTimeSlots = hourlyTimeSlots.toSet().toList();

          // Update the state with the available time slots and open the modal
          setState(() {
            availableTimeSlots = hourlyTimeSlots;
            selectedTimeSlot =
                availableTimeSlots.first; // Preselect the first time slot
          });

          // Show modal for selecting the time slot and confirming appointment
          await Future.delayed(Duration.zero, () {
            showModalService(auth, clinicprofile, name, pickedDate);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No available time slots for the selected day."),
            ),
          );
        }
      }
    } catch (error) {
      debugPrint("Error selecting date and time: $error");
    }
  }

// Show modal to select time slot and confirm appointment
  void showModalService(AuthProviderClass auth, String clinicprofile,
      String name, DateTime selectedDate) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Time Slot"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: selectedTimeSlot,
                    items: availableTimeSlots.map((timeSlot) {
                      return DropdownMenuItem(
                        value: timeSlot,
                        child: Text(timeSlot),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedTimeSlot = value;
                      });
                    },
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
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Check if date and time slot are selected
                if (_selectedDateTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a date."),
                    ),
                  );
                  return;
                }

                if (selectedTimeSlot == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a time slot."),
                    ),
                  );
                  return;
                }

                if (_formKey.currentState!.validate()) {
                  // Store the selected time slot as a timestamp in Firebase
                  DateTime appointmentDateTime = _combineDateAndTime(
                      _selectedDateTime!, selectedTimeSlot!);
                  _uploadAppointment(
                          auth, clinicprofile, name, appointmentDateTime)
                      .then((value) {
                    Navigator.of(context).pop();
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

// Combine selected date and time slot into a single DateTime object
  DateTime _combineDateAndTime(DateTime date, String time) {
    final format = DateFormat.jm(); // Parse the time in "h:mm a" format
    DateTime parsedTime = format.parse(time);

    return DateTime(
      date.year,
      date.month,
      date.day,
      parsedTime.hour,
      parsedTime.minute,
    );
  }

// Function to generate available time slots based on start and end times
  List<String> _generateTimeSlots(
      List<Map<String, dynamic>> timeRanges, DateTime selectedDate) {
    List<String> timeSlots = [];

    // Iterate over each time range (e.g., 8:00 AM - 12:00 PM and 1:00 PM - 5:00 PM)
    for (var range in timeRanges) {
      String start = range['startTime'];
      String end = range['endTime'];

      // Parse start and end times
      DateTime startTime = _parseTime(selectedDate, start);
      DateTime endTime = _parseTime(selectedDate, end);

      // Generate hourly slots within the time range
      while (startTime.isBefore(endTime)) {
        timeSlots.add(
            DateFormat.jm().format(startTime)); // e.g., "8:00 AM", "9:00 AM"
        startTime =
            startTime.add(const Duration(hours: 1)); // Increment by 1 hour
      }
    }

    return timeSlots;
  }

  String cleanTimeString(String timeString) {
    // Remove any non-ASCII characters and trim the string
    String cleanedTime =
        timeString.replaceAll(RegExp(r'[^\x00-\x7F]'), '').trim();
    return cleanedTime;
  }

  DateTime _parseTime(DateTime selectedDate, String timeString) {
    try {
      // Debug raw string to see any unseen characters
      debugPrint("Raw time string before parsing: '$timeString'");

      // Manually parse the time string without using DateFormat
      List<String> timeParts = timeString.split(RegExp(r'[: ]'));

      if (timeParts.length < 3) {
        throw FormatException("Invalid time format: $timeString");
      }

      // Extract hour, minute, and AM/PM parts
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      String period = timeParts[2].toLowerCase();

      // Adjust hour based on AM/PM
      if (period == 'pm' && hour != 12) {
        hour += 12;
      } else if (period == 'am' && hour == 12) {
        hour = 0;
      }

      // Return the combined DateTime object
      return DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
          hour, minute);
    } catch (e) {
      debugPrint("Error in manual parsing: $e");
      throw FormatException("Manual parsing failed for time: $timeString");
    }
  }

// Upload the appointment to Firebase
  Future<void> _uploadAppointment(
    AuthProviderClass auth,
    String clinicprofile,
    String name,
    DateTime appointmentDateTime,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointment')
          .doc(widget.documentID)
          .collection('vet')
          .add({
        'appointmentdate': appointmentDateTime,
        'name': "${auth.userModel!.fname} ${auth.userModel!.lname}",
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
        'appointmentdate': appointmentDateTime,
        'name': "${auth.userModel!.fname} ${auth.userModel!.lname}",
        'profile': auth.userModel!.imageprofile,
        'userid': auth.userModel!.vetid,a
        'vetprofile': clinicprofile,
        'clinic': name,
        'clinicid': widget.documentID,
        'status': 0,
        'purpose': purpose.text,
        'service': selectedValue,
      });
    } catch (error) {
      debugPrint("$error");
    }
  }
}

// ======
// ignore_for_file: use_build_context_synchronously

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:ipet/client/pages/chat.dart';
// import 'package:ipet/client/widgets/ratingsInformation.dart';
// import 'package:ipet/client/widgets/ratingsreview.dart';
// import 'package:ipet/client/widgets/singlevetData.dart';
// import 'package:ipet/controller/map/polyline.dart';
// import 'package:ipet/misc/function.dart';
// import 'package:ipet/misc/themestyle.dart';
// import 'package:ipet/model/Authprovider.dart';
// import 'package:ipet/utils/firebasehook.dart';
// import 'package:provider/provider.dart';

// class ClinicViewSingle extends StatefulWidget {
//   final String documentID;
//   const ClinicViewSingle({super.key, required this.documentID});

//   @override
//   State<ClinicViewSingle> createState() => _ClinicViewSingleState();
// }

// class _ClinicViewSingleState extends State<ClinicViewSingle> {
//   final TextEditingController comments = TextEditingController();
//   final TextEditingController purpose = TextEditingController();
//   List<String> services = [];
//   bool iscomminting = false;
//   double ratereivew = 0;
//   double staffrate = 0;
//   double pricrrate = 0;
//   DateTime? _selectedDateTime;
//   String? selectedValue;
//   String? selectedaccomodation;
//   bool isuploading = false;
//   @override
//   void initState() {
//     super.initState();
//     getlistofservices();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     purpose.dispose();
//     comments.dispose();
//   }

//   Future<void> getratings(
//       String name, String impageprofile, double rates, String userid) async {
//     setState(() {
//       iscomminting = true;
//     });
//     try {
//       await FirebaseFirestore.instance
//           .collection('ratings')
//           .doc(widget.documentID)
//           .collection('reviews')
//           .doc(userid)
//           .set({
//         "name": name,
//         "date": DateTime.now(),
//         "imageprofile": impageprofile,
//         "comment": comments.text,
//         "pricerate": pricrrate,
//         "accomodation": selectedaccomodation,
//         "staffrate": staffrate,
//         "rates": rates
//       }).then((value) {
//         setState(() {
//           iscomminting = false;
//         });
//       });
//     } catch (e) {
//       setState(() {
//         iscomminting = false;
//       });
//       debugPrint("$e");
//     }
//   }

//   // "profile": "${userauth.userModel!.imageprofile}",
//   // "name": "${userauth.userModel!.fname}",

//   @override
//   Widget build(BuildContext context) {
//     final userauth = Provider.of<AuthProviderClass>(context);
//     return Scaffold(
//       floatingActionButton: Container(
//         decoration: BoxDecoration(
//           color: maincolor,
//           shape: BoxShape.circle,
//         ),
//         child: IconButton(
//             onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         ChatVet(vetID: "${widget.documentID}"))),
//             icon: Icon(
//               Icons.message_outlined,
//               color: Colors.white,
//             )),
//       ),
//       body: SingleChildScrollView(
//         child: FutureBuilder(
//             future: usercred
//                 .doc(widget.documentID)
//                 .collection('vertirenary')
//                 .doc(widget.documentID)
//                 .get(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return LinearProgressIndicator(
//                   color: maincolor,
//                 );
//               } else if (snapshot.hasData) {
//                 debugPrint("dodument = ${widget.documentID}");
//                 final data = snapshot.data!.data();

//                 List<dynamic> services = data!['services'] ?? [];
//                 List<dynamic> specialties = data['specialties'] ?? [];
//                 List<dynamic> operations = data["operation"];
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Stack(
//                       children: [
//                         SizedBox(
//                             width: MediaQuery.of(context).size.width,
//                             height: 300,
//                             child: VetClinicUserClientPolyline(
//                               userLat:
//                                   double.parse("${userauth.usermapping!.lat}"),
//                               userLon:
//                                   double.parse("${userauth.usermapping!.long}"),
//                               clinicLat: double.parse("${data['lat']}"),
//                               clinicLon: double.parse("${data['long']}"),
//                               ispolyline: true,
//                             )),

//                         // Container(
//                         //   width: MediaQuery.of(context).size.width,
//                         //   height: 300,
//                         //   decoration: BoxDecoration(
//                         //       image: DecorationImage(
//                         //           fit: BoxFit.cover,
//                         //           image: NetworkImage(
//                         //               "${data['imageprofile'] ?? ""}"))),
//                         // )
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     RatingsDetails(
//                       data: data,
//                       widget: widget,
//                       viewrate: () {
//                         ratingmoddal(
//                             "${userauth.userModel!.fname}",
//                             "${userauth.userModel!.imageprofile}",
//                             "${userauth.userModel!.vetid}");
//                       },
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     SingleVetData(
//                       operations: operations,
//                       data: data,
//                       services: services,
//                       specialties: specialties,
//                       widget: widget,
//                       showmod: () {
//                         _selectDateTime(
//                             context,
//                             userauth,
//                             "${data['imageprofile'] ?? ""}",
//                             "${data['clinicname'] ?? ""}");
//                       },
//                     )
//                   ],
//                 );
//               } else {
//                 return Container();
//               }
//             }),
//       ),
//     );
//   }

//   void ratingmoddal(String name, String impageprofiles, String userid) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return SingleChildScrollView(
//             child: AlertDialog(
//                 title: const MainFont(
//                   title: "Give us Feedback",
//                   fweight: FontWeight.normal,
//                 ),
//                 actions: [
//                   iscomminting == false
//                       ? TextButton(
//                           onPressed: () {
//                             iscomminting == false
//                                 ? getratings(name, impageprofiles, ratereivew,
//                                         userid)
//                                     .then((value) => Navigator.pop(context))
//                                 : null;
//                           },
//                           child: const MainFont(title: "Submit"))
//                       : CircularProgressIndicator(
//                           color: maincolor,
//                         ),
//                 ],
//                 content: SizedBox(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Ratingsreview(
//                         ratings: (rating) {
//                           setState(() {
//                             ratereivew = rating;
//                             debugPrint("$rating");
//                           });
//                         },
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       TextFormField(
//                         controller: comments,
//                         maxLength: 340,
//                         maxLengthEnforcement: MaxLengthEnforcement.enforced,
//                         decoration: const InputDecoration(
//                             hintText: "Comments", border: OutlineInputBorder()),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       const MainFont(title: "Rate our Staff"),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Ratingsreview(ratings: (ratings) {
//                         setState(() {
//                           staffrate = ratings;
//                           debugPrint("staff= $staffrate");
//                         });
//                       }),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       const MainFont(title: "Accomodation"),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width,
//                         child: DropdownButtonFormField<String>(
//                           style: const TextStyle(
//                               fontSize: 12, color: Colors.black),
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10))),
//                           hint: const Text('Accomodotion Feedback'),
//                           value: selectedaccomodation,
//                           items: accomodation
//                               .map((e) => DropdownMenuItem(
//                                   value: e, child: MainFont(title: e)))
//                               .toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               selectedaccomodation = value;
//                               debugPrint("$selectedaccomodation");
//                             });
//                           },
//                           validator: (value) =>
//                               value == null ? 'Rate our accomodation' : null,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       const MainFont(title: "Price "),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Ratingsreview(ratings: (ratings) {
//                         setState(() {
//                           pricrrate = ratings;
//                           debugPrint("$ratings");
//                         });
//                       }),
//                     ],
//                   ),
//                 )),
//           );
//         });
//   }

//   Future<void> _selectDateTime(
//     BuildContext context,
//     AuthProviderClass auth,
//     String clinicprofile,
//     String name,
//   ) async {
//     try {
//       final DateTime? pickedDate = await showDatePicker(
//         context: context,
//         initialDate: _selectedDateTime ?? DateTime.now(),
//         firstDate: DateTime.now(),
//         lastDate: DateTime(2101),
//       );

//       if (pickedDate != null) {
//         final TimeOfDay? pickedTime = await showTimePicker(
//           context: context,
//           initialTime: TimeOfDay.now(),
//         );

//         if (pickedTime != null) {
//           setState(() {
//             isuploading = true;
//           });

//           _selectedDateTime = DateTime(
//             pickedDate.year,
//             pickedDate.month,
//             pickedDate.day,
//             pickedTime.hour,
//             pickedTime.minute,
//           );
//           showModalService(auth, clinicprofile, name);

//           setState(() {
//             isuploading = false;
//           });
//         }
//       }
//     } catch (error) {
//       debugPrint("Error selecting date and time: $error");
//       setState(() {
//         isuploading = false;
//       });
//     }
//   }

//   Future<void> getlistofservices() async {
//     try {
//       DocumentSnapshot listofservice = await usercred
//           .doc(widget.documentID)
//           .collection("vertirenary")
//           .doc(widget.documentID)
//           .get();

//       if (listofservice.exists) {
//         Map<String, dynamic>? fetchdata =
//             listofservice.data() as Map<String, dynamic>?;

//         if (fetchdata != null && fetchdata.containsKey('services')) {
//           List<dynamic> fetchedServices = fetchdata['services'];

//           setState(() {
//             services = List<String>.from(fetchedServices);
//           });

//           debugPrint("service = $services");
//         }
//       }
//     } catch (e) {
//       debugPrint("Error fetching services: $e");
//     }
//   }

//   final _formKey = GlobalKey<FormState>();
//   String get formattedDate {
//     if (_selectedDateTime == null) {
//       return 'No date selected';
//     } else {
//       return DateFormat('MMMM dd, yyyy').format(_selectedDateTime!);
//     }
//   }

//   void showModalService(
//       AuthProviderClass auth, String clinicprofile, String name) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Purpose of your appointment"),
//           content: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text("You scheduled: $formattedDate"),
//                 const SizedBox(height: 10),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: DropdownButtonFormField<String>(
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10))),
//                     hint: const Text('Service'),
//                     value: selectedValue,
//                     items: services
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedValue = value;
//                       });
//                     },
//                     validator: (value) =>
//                         value == null ? 'Please select a service' : null,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   controller: purpose,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     labelText: 'Purpose',
//                   ),
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter a purpose'
//                       : null,
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   updloadlisofapoinments(auth, clinicprofile, name)
//                       .then((value) {
//                     if (mounted) {
//                       Navigator.of(context).pop();
//                     }
//                   });
//                 }
//               },
//               child: const Text('Submit'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> updloadlisofapoinments(
//       AuthProviderClass auth, String clinicprofile, String name) async {
//     try {
//       if (_formKey.currentState!.validate()) {
//         await FirebaseFirestore.instance
//             .collection('appointment')
//             .doc(widget.documentID)
//             .collection('vet')
//             .add({
//           'appoinmentdate': _selectedDateTime,
//           'name': "${auth.userModel!.fname} ${auth.userModel!.lname} ",
//           'profile': auth.userModel!.imageprofile,
//           'userid': auth.userModel!.vetid,
//           'vetprofile': clinicprofile,
//           'clinic': name,
//           'clinicid': widget.documentID,
//           'status': 0,
//           'purpose': purpose.text,
//           'service': selectedValue,
//         });
//         await FirebaseFirestore.instance
//             .collection('userappointment')
//             .doc(auth.userModel!.vetid)
//             .collection('user')
//             .add({
//           'appoinmentdate': _selectedDateTime,
//           'name': "${auth.userModel!.fname} ${auth.userModel!.lname} ",
//           'profile': auth.userModel!.imageprofile,
//           'userid': auth.userModel!.vetid,
//           'vetprofile': clinicprofile,
//           'clinic': name,
//           'clinicid': widget.documentID,
//           'status': 0,
//           'purpose': purpose.text,
//           'service': selectedValue,
//         });
//         setState(() {});
//       }
//     } catch (error) {
//       debugPrint("$error");
//     }
//   }
// }
