import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipet/controller/uploadimagefield.dart';
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
  final ImagePicker _imageDTI = ImagePicker();
  final ImagePicker _imageBIR = ImagePicker();

  XFile? xfiledti;
  XFile? xfilebir;
  bool isobscure = true;
  bool isconfirm = true;

  Future<void> pickimageDTI() async {
    XFile? filepath = await _imageDTI.pickImage(source: ImageSource.gallery);

    setState(() {
      if (filepath != null) {
        xfiledti = filepath;
      } else {
        xfiledti = null;
      }
    });
  }

  Future<void> pickimageBIR() async {
    XFile? filepath = await _imageBIR.pickImage(source: ImageSource.gallery);

    setState(() {
      if (filepath != null) {
        xfilebir = filepath;
      } else {
        xfilebir = null;
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
                    uppertitle: "Provide TIN Number",
                    fieldname: "000-000-000-00000",
                    textvalidator: "TIN 000-000-000-00000"),
                const SizedBox(
                  height: 15,
                ),
                UploadImageField(
                  title: "Upload DTI Permit",
                  xfiledti: xfiledti,
                  pickimage: () {
                    pickimageDTI();
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                UploadImageField(
                  title: "Upload BIR Permit",
                  xfiledti: xfilebir,
                  pickimage: () {
                    pickimageBIR();
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                GlobalButton(
                    callback: () {
                      uploadsecondcred();
                    },
                    title: "Proceed")
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> uploadsecondcred() async {
    try {
      if (_formkey.currentState!.validate()) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const VetGovController()));
      }
    } catch (error) {}
  }
}
