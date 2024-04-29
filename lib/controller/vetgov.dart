import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipet/misc/formtext.dart';
import 'package:ipet/misc/themestyle.dart';

class VetGovController extends StatefulWidget {
  const VetGovController({super.key});

  @override
  State<VetGovController> createState() => _VetGovControllerState();
}

class _VetGovControllerState extends State<VetGovController> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController tinID = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  XFile? xFile;
  bool isobscure = true;
  bool isconfirm = true;
  Future<void> pickimage() async {
    XFile? filepath = await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (filepath != null) {
        xFile = filepath;
      } else {
        xFile = null;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    tinID.dispose();
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Goverment ID",
                  style: TextStyle(
                      fontSize: 25,
                      color: maincolor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 5,
                  width: 70,
                  decoration: BoxDecoration(
                      color: maincolor, borderRadius: BorderRadius.circular(9)),
                ),
                const SizedBox(
                  height: 25,
                ),
                const SizedBox(
                  height: 15,
                ),
                Textformtype(
                    textEditingController: tinID,
                    uppertitle: "Provide clinic TIN",
                    fieldname: "TIN ID",
                    textvalidator: "TIN 000-000-000-00000"),
                const SizedBox(
                  height: 15,
                ),
                GlobalButton(callback: () {}, title: "Proceed")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
