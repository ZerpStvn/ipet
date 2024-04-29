// // ignore: avoid_web_libraries_in_flutter
// // import 'dart:html' as html;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:ipet/admin/controller/gmap.dart';
// import 'package:ipet/misc/themestyle.dart';

// class ClinicDataInfo extends StatefulWidget {
//   const ClinicDataInfo({super.key});

//   @override
//   State<ClinicDataInfo> createState() => _ClinicDataInfoState();
// }

// class _ClinicDataInfoState extends State<ClinicDataInfo> {
//   final _formkey = GlobalKey<FormState>();
//   final TextEditingController nameofclinic = TextEditingController();
//   final TextEditingController ownersfirstname = TextEditingController();
//   final TextEditingController ownerslastname = TextEditingController();
//   final TextEditingController phonenumber = TextEditingController();
//   final TextEditingController emailaddress = TextEditingController();
//   final TextEditingController datepick = TextEditingController();
//   final TextEditingController operationtime = TextEditingController();
//   String latittude = "";
//   String longitude = "";
//   bool isaddload = false;
//   List<html.File>? _mediaFilelist;
//   final ImagePicker picker = ImagePicker();

//   void handleFileUpload(html.FileUploadInputElement uploadInput) {
//     setState(() {
//       _mediaFilelist = uploadInput.files;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     nameofclinic.dispose();
//     ownersfirstname.dispose();
//     ownerslastname.dispose();
//     phonenumber.dispose();
//     emailaddress.dispose();
//     datepick.dispose();
//     operationtime.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: Column(
//               children: [
//                 Form(
//                   key: _formkey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("Enter Clinic Name"),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       TextFormField(
//                         controller: nameofclinic,
//                         validator: (val) {
//                           if (val!.isEmpty) {
//                             return "Enter the name of the Clinic";
//                           } else {
//                             return null;
//                           }
//                         },
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.next,
//                         decoration:
//                             const InputDecoration(border: OutlineInputBorder()),
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text("Owners First Name"),
//                                 const SizedBox(
//                                   height: 5,
//                                 ),
//                                 TextFormField(
//                                   validator: (val) {
//                                     if (val!.isEmpty) {
//                                       return "Enter First name";
//                                     } else {
//                                       return null;
//                                     }
//                                   },
//                                   controller: ownersfirstname,
//                                   keyboardType: TextInputType.text,
//                                   textInputAction: TextInputAction.next,
//                                   decoration: const InputDecoration(
//                                       hintText: "Enter First name",
//                                       border: OutlineInputBorder()),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 15,
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text("Owners Last Name"),
//                                 const SizedBox(
//                                   height: 5,
//                                 ),
//                                 TextFormField(
//                                   validator: (val) {
//                                     if (val!.isEmpty) {
//                                       return "Enter Last name";
//                                     } else {
//                                       return null;
//                                     }
//                                   },
//                                   controller: ownerslastname,
//                                   textInputAction: TextInputAction.next,
//                                   decoration: const InputDecoration(
//                                       hintText: "Enter Last name",
//                                       border: OutlineInputBorder()),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       const Text("Contact Number"),
//                       TextFormField(
//                         validator: (val) {
//                           if (val!.isEmpty) {
//                             return "Provide Contact number";
//                           } else {
//                             return null;
//                           }
//                         },
//                         controller: phonenumber,
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.next,
//                         decoration: const InputDecoration(
//                             hintText: "Enter Contact Number",
//                             border: OutlineInputBorder()),
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       const Text("Email Address"),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       TextFormField(
//                         validator: (val) {
//                           if (val!.isEmpty) {
//                             return "Enter Email Address";
//                           } else {
//                             return null;
//                           }
//                         },
//                         controller: emailaddress,
//                         textInputAction: TextInputAction.next,
//                         decoration: const InputDecoration(
//                             hintText: "Enter Email Address",
//                             border: OutlineInputBorder()),
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text("Date The Clinic Established"),
//                                 const SizedBox(
//                                   height: 5,
//                                 ),
//                                 TextFormField(
//                                   validator: (val) {
//                                     if (val!.isEmpty) {
//                                       return "Provide Date The Clinic Established";
//                                     } else {
//                                       return null;
//                                     }
//                                   },
//                                   onTap: () {
//                                     _selectdate();
//                                   },
//                                   readOnly: true,
//                                   controller: datepick,
//                                   keyboardType: TextInputType.text,
//                                   textInputAction: TextInputAction.next,
//                                   decoration: const InputDecoration(
//                                       prefixIcon:
//                                           Icon(Icons.calendar_month_outlined),
//                                       hintText: "Clinic Establish (mm-dd-yyyy)",
//                                       border: OutlineInputBorder()),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 15,
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text("Clinic Operation Hour"),
//                                 const SizedBox(
//                                   height: 5,
//                                 ),
//                                 SizedBox(
//                                   width: double.infinity,
//                                   height: 55,
//                                   child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                           backgroundColor: maincolor,
//                                           shape: const RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(5)))),
//                                       onPressed: _selectDateTime,
//                                       child: const MainFont(
//                                         title: 'Add Clinic Operation Time',
//                                         color: Colors.white,
//                                       )),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: clinicSchedule.length,
//                         itemBuilder: (context, index) {
//                           return ListTile(
//                             title: Text(
//                               '${clinicSchedule[index]['day']}: ${clinicSchedule[index]['startTime']} - ${clinicSchedule[index]['endTime']}',
//                             ),
//                           );
//                         },
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       GlobalButton(
//                           callback: () {
//                             html.FileUploadInputElement uploadInput =
//                                 html.FileUploadInputElement();
//                             uploadInput.multiple = true;
//                             uploadInput.accept = 'image/*';
//                             uploadInput.click();
//                             uploadInput.onChange.listen((event) {
//                               handleFileUpload(uploadInput);
//                             });
//                           },
//                           title: "Select Image"),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       if (_mediaFilelist != null)
//                         GridView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 3,
//                             crossAxisSpacing: 4,
//                             mainAxisSpacing: 4,
//                           ),
//                           itemCount: _mediaFilelist!.length,
//                           itemBuilder: (context, index) {
//                             return Image.network(
//                               html.Url.createObjectUrl(_mediaFilelist![index]),
//                               fit: BoxFit.cover,
//                             );
//                           },
//                         ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       SizedBox(
//                           height: 50,
//                           width: double.infinity,
//                           child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8)),
//                                   backgroundColor: maincolor),
//                               onPressed: () {
//                                 setState(() {
//                                   // print("$latittude, $longitude");
//                                 });
//                               },
//                               child: isaddload == false
//                                   ? const Text(
//                                       "Submit",
//                                       style: TextStyle(color: Colors.white),
//                                     )
//                                   : const CircularProgressIndicator(
//                                       color: Colors.white,
//                                     )))
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Expanded(
//             child: Card(
//           elevation: 10,
//           child: Column(
//             children: [
//               SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height,
//                   child: WebMapController(
//                     latitude: latittude,
//                     longtitude: longitude,
//                   ))
//             ],
//           ),
//         ))
//       ],
//     );
//   }

//   Future<void> _selectdate() async {
//     DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: DateTime.now(),
//         firstDate: DateTime(2000),
//         lastDate: DateTime(2100));

//     if (picked != null) {
//       setState(() {
//         datepick.text = datepick.text = DateFormat('MM-dd-yyyy').format(picked);
//       });
//     }
//   }

//   List<Map<String, String>> clinicSchedule = [];

//   Future<void> _selectDateTime() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );

//     if (pickedDate != null) {
//       TimeOfDay? pickedStartTime = await showTimePicker(
//         // ignore: use_build_context_synchronously
//         context: context,
//         initialTime: const TimeOfDay(hour: 8, minute: 0), // Default start time
//       );

//       if (pickedStartTime != null) {
//         TimeOfDay? pickedEndTime = await showTimePicker(
//           // ignore: use_build_context_synchronously
//           context: context,
//           initialTime: const TimeOfDay(hour: 17, minute: 0), // Default end time
//         );

//         if (pickedEndTime != null) {
//           setState(() {
//             clinicSchedule.add({
//               'day': DateFormat('EEEE').format(pickedDate),
//               'startTime': pickedStartTime.format(context),
//               'endTime': pickedEndTime.format(context),
//             });
//           });
//         }
//       }
//     }
//   }
// }
