// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ipet/client/pages/bookuser.dart';
import 'package:ipet/client/pages/chat.dart';
import 'package:ipet/client/pages/service/pricetable.dart';
import 'package:ipet/client/widgets/bookingdt.dart';
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
  const ClinicViewSingle({
    super.key,
    required this.documentID,
  });

  @override
  State<ClinicViewSingle> createState() => _ClinicViewSingleState();
}

class _ClinicViewSingleState extends State<ClinicViewSingle> {
  bool? canBookToday;
  final TextEditingController comments = TextEditingController();
  final TextEditingController purpose = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Services from Firestore
  List<String> services = [];

  // For the rating modal
  bool iscomminting = false;
  double ratereivew = 0;
  double staffrate = 0;
  double pricrrate = 0;

  // For appointment date/time selection
  DateTime? _selectedDateTime;
  String? selectedValue;

  bool isuploading = false;

  // Fetched user data
  Map<String, dynamic>? userData;
  Map<String, dynamic>? checktypeclinic;

  // ------------------------------
  // New State Variables for Pet Info
  // ------------------------------
  String? selectedPetType;
  String? selectedPetSize;
  String? selectedPetCount;

  final List<String> petTypes = ['Dog', 'Cat', 'Bird', 'cat'];
  final List<String> petSizes = ['Small', 'Medium', 'Large'];
  final List<String> petCounts = [
    '1',
    '2',
    '3',
  ];

  // ------------------------------
  // Lifecycle Methods
  // ------------------------------
  @override
  void initState() {
    super.initState();
    fetchUserDataClinic();
    getlistofservices();
    _loadCapacityInfo();
    fetchUserDataClinictype();
  }

  @override
  void dispose() {
    super.dispose();
    purpose.dispose();
    comments.dispose();
  }

  // ------------------------------
  // Fetch Clinic / User Data
  // ------------------------------
  Future<void> fetchUserDataClinictype() async {
    try {
      final fetchdata = await FirebaseFirestore.instance
          .collection('pet_services')
          .doc(widget.documentID)
          .get();

      if (fetchdata.exists) {
        setState(() {
          checktypeclinic = fetchdata.data();
        });
      } else {
        print('Document does not exist.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchUserDataClinic() async {
    try {
      final fetchdata = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.documentID)
          .get();

      if (fetchdata.exists) {
        setState(() {
          userData = fetchdata.data();
        });
      } else {
        print('Document does not exist.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
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

  // ------------------------------
  // Rating / Review Function
  // ------------------------------
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

  // ------------------------------
  // Chat / Message Function
  // ------------------------------
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

  // ------------------------------
  // Booking Checking / Flow
  // ------------------------------
  Future<bool> _checkUserBookingExists(String hotelclinicid) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return false; // Not logged in

    final snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('hotelclinicid', isEqualTo: hotelclinicid)
        .where('userID', isEqualTo: currentUser.uid)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<void> _loadCapacityInfo() async {
    final result = await _canScheduleAppointment(
        widget.documentID, _selectedDateTime ?? DateTime.now());
    setState(() {
      canBookToday = result; // true or false
    });
  }

  // ------------------------------
  // UI - build()
  // ------------------------------
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
              builder: (context) => ChatVet(
                vetID: "${widget.documentID}",
                email: userData!['email'],
              ),
            ),
          ),
          icon: const Icon(
            Icons.message_outlined,
            color: Colors.white,
          ),
        ),
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
              return LinearProgressIndicator(color: maincolor);
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('pet_services')
                                  .doc(widget.documentID)
                                  .get(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData || snapshot.hasError) {
                                  return Container();
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
                                } else {
                                  var checktype =
                                      snapshot.data!.data()!['type'] ??
                                          "Clinic";
                                  if (checktype == "Hotel") {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(),
                                              backgroundColor: maincolor),
                                          onPressed: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Bookinguser(
                                                  hotelclinicid:
                                                      widget.documentID,
                                                  hotelclinicemail:
                                                      userData!['email'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Book Now",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(),
                                              backgroundColor: maincolor),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BookingDetails(
                                                  hotelclinicid:
                                                      widget.documentID,
                                                  hotelclinicidemail:
                                                      userData!['email'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "View Booking Details",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SingleVetData(
                        canBookToday: canBookToday ?? true,
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
                            "${data['clinicname'] ?? ""}",
                          );
                        },
                        vetDocID: widget.documentID,
                      ),
                    ],
                  )
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  // ------------------------------
  // Rating Modal
  // ------------------------------
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
                            ? getratings(
                                    name, impageprofiles, ratereivew, userid)
                                .then((value) => Navigator.pop(context))
                            : null;
                      },
                      child: const MainFont(title: "Submit"),
                    )
                  : CircularProgressIndicator(color: maincolor),
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
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: comments,
                    maxLength: 340,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: const InputDecoration(
                      hintText: "Comments",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const MainFont(title: "Rate our Staff"),
                  const SizedBox(height: 10),
                  Ratingsreview(
                    ratings: (ratings) {
                      setState(() {
                        staffrate = ratings;
                        debugPrint("staff= $staffrate");
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const MainFont(title: "Accomodation"),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButtonFormField<String>(
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      hint: const Text('Accomodotion Feedback'),
                      value: selectedaccomodation,
                      items: accomodation
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: MainFont(title: e),
                              ))
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
                  const SizedBox(height: 20),
                  const MainFont(title: "Price "),
                  const SizedBox(height: 10),
                  Ratingsreview(
                    ratings: (ratings) {
                      setState(() {
                        pricrrate = ratings;
                        debugPrint("$ratings");
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ------------------------------
  // Show Operation Time & DateTime Selection
  // ------------------------------
  void showoperationtimeavailable(
    dynamic operations,
    AuthProviderClass userauth,
    String clinicprofile,
    String name,
  ) {
    int countdown = 3; // Start with 3 seconds
    bool isContinueEnabled = false;
    Timer? countdownTimer;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          if (countdownTimer == null) {
            countdownTimer =
                Timer.periodic(const Duration(seconds: 1), (timer) {
              if (countdown > 1) {
                countdown--;
                if (mounted) {
                  setState(() {});
                }
              } else {
                countdown = 0;
                isContinueEnabled = true;
                timer.cancel();
                if (mounted) {
                  setState(() {});
                }
              }
            });
          }

          return AlertDialog(
            title: const Text("Operation Time"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...operations.map((e) {
                  return Text(
                    "${e['day']} ${e['startTime']} - ${e['endTime']} ",
                  );
                }).toList(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  countdownTimer?.cancel();
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: isContinueEnabled
                    ? () {
                        countdownTimer?.cancel();
                        _selectDateTime(
                          context,
                          userauth,
                          clinicprofile,
                          name,
                        );
                      }
                    : null,
                child: countdown > 0
                    ? Text("Continue ($countdown)")
                    : const Text("Continue"),
              ),
            ],
          );
        });
      },
    ).then((_) {
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
      final snapshot = await FirebaseFirestore.instance
          .collection('appointment')
          .doc(widget.documentID)
          .collection('vet')
          .get();

      final bookedSlots = snapshot.docs
          .map((doc) {
            final timestamp = doc['appoinmentdate'] as Timestamp?;
            return timestamp?.toDate();
          })
          .whereType<DateTime>()
          .toList();

      bool isSelectableDate(DateTime date) {
        return true; // Let’s not disable any date
      }

      DateTime initialDate = _selectedDateTime ?? DateTime.now();

      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        selectableDayPredicate: isSelectableDate,
      );

      if (pickedDate != null) {
        final bookedTimes = bookedSlots
            .where((slot) =>
                slot.year == pickedDate.year &&
                slot.month == pickedDate.month &&
                slot.day == pickedDate.day)
            .map((slot) => TimeOfDay(hour: slot.hour, minute: slot.minute))
            .toList();

        final availableTimes = List.generate(24, (hour) {
          final time = TimeOfDay(hour: hour, minute: 0);
          final nextHour = TimeOfDay(hour: hour + 1, minute: 0);
          return !bookedTimes.contains(time) && !bookedTimes.contains(nextHour)
              ? time
              : null;
        }).whereType<TimeOfDay>().toList();

        if (availableTimes.isNotEmpty) {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: false),
                child: child ?? const SizedBox(),
              );
            },
          );

          if (pickedTime != null) {
            final DateTime selectedTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              0,
            );

            // Check if the selected time is booked
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

              // Show the modal to select purpose, service, pet type, etc.
              showModalService(auth, clinicprofile, name);

              setState(() {
                isuploading = false;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("The selected time is Already taken."),
                ),
              );
              Navigator.pop(context);
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
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

  // ------------------------------
  // "Purpose of Your Appointment" Dialog
  // ------------------------------
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("You scheduled: $formattedDate"),
                  const SizedBox(height: 10),
                  // Service Dropdown
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      hint: const Text('Service'),
                      value: selectedValue,
                      items: services.map((service) {
                        return DropdownMenuItem(
                          value: service,
                          child: Text(service),
                        );
                      }).toList(),
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
                  // Purpose TextField
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
                  const SizedBox(height: 10),
                  // Pet Type Dropdown
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      hint: const Text('Select Pet Type'),
                      value: selectedPetType,
                      items: petTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPetType = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a pet type' : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Pet Size Dropdown
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      hint: const Text('Select Pet Size'),
                      value: selectedPetSize,
                      items: petSizes.map((size) {
                        return DropdownMenuItem(
                          value: size,
                          child: Text(size),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPetSize = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a pet size' : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Number of Pets
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      hint: const Text('Number of Pets'),
                      value: selectedPetCount,
                      items: petCounts.map((count) {
                        return DropdownMenuItem(
                          value: count,
                          child: Text(count),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPetCount = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select how many pets' : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  updloadlisofapoinments(auth, clinicprofile, name).then((_) {
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

  // ------------------------------
  // Check Clinic Capacity & Save to Firestore
  // ------------------------------
  Future<bool> _canScheduleAppointment(
      String clinicId, DateTime selectedDate) async {
    final clinicDoc = await FirebaseFirestore.instance
        .collection('pet_services')
        .doc(clinicId)
        .get();

    if (!clinicDoc.exists) {
      debugPrint('No clinic doc found; defaulting capacity to 0');
      return false;
    }

    final clinicData = clinicDoc.data();
    final int capacity = (clinicData?['clinicCapacity'] ?? 0) as int;

    final DateTime dayStart =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final DateTime dayEnd = dayStart.add(const Duration(days: 1));

    final snapshot = await FirebaseFirestore.instance
        .collection('appointment')
        .doc(clinicId)
        .collection('vet')
        .where('appoinmentdate', isGreaterThanOrEqualTo: dayStart)
        .where('appoinmentdate', isLessThan: dayEnd)
        .get();

    final int currentAppointmentsCount = snapshot.size;
    debugPrint(
      'Current appointments on that day: $currentAppointmentsCount / $capacity',
    );

    return currentAppointmentsCount < capacity;
  }

  Future<void> updloadlisofapoinments(
      AuthProviderClass auth, String clinicprofile, String name) async {
    try {
      if (_formKey.currentState!.validate()) {
        final canSchedule = await _canScheduleAppointment(
            widget.documentID, _selectedDateTime!);

        if (!canSchedule) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Clinic is fully booked for today.")),
          );
          return;
        }

        // 1) Save to the clinic's 'appointment/vet' subcollection
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
          // New fields for pet info
          'petType': selectedPetType,
          'petSize': selectedPetSize,
          'petCount': selectedPetCount,
        });

        // 2) Save to the user's 'userappointment/user' subcollection
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
          // New fields for pet info
          'petType': selectedPetType,
          'petSize': selectedPetSize,
          'petCount': selectedPetCount,
        }).then((_) {
          _sendMessage();
        });

        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Appointment scheduled successfully!"),
          ),
        );
      }
    } catch (error) {
      debugPrint("$error");
    }
  }
}

// If you're using them in your rating modal:
List<String> accomodation = ['Excellent', 'Good', 'Fair', 'Poor'];
String? selectedaccomodation;
