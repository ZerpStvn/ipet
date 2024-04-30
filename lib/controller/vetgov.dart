import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipet/controller/uploadimagefield.dart';
import 'package:ipet/controller/vetcred.dart';
import 'package:ipet/misc/formtext.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:ipet/model/vetirinary.dart';
import 'package:ipet/utils/firebasehook.dart';

class VetGovController extends StatefulWidget {
  final String documentID;
  const VetGovController({super.key, required this.documentID});

  @override
  State<VetGovController> createState() => _VetGovControllerState();
}

class _VetGovControllerState extends State<VetGovController> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController tinID = TextEditingController();
  final ImagePicker _imageDTI = ImagePicker();
  final ImagePicker _imageBIR = ImagePicker();
  final VeterinaryModel veterinaryModel = VeterinaryModel();
  XFile? xfiledti;
  XFile? xfilebir;
  bool isobscure = true;
  bool isconfirm = true;
  bool isuploading = false;

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
  }

  @override
  void initState() {
    super.initState();
  }

  Future<String> uploadImageToFirebaseBIR(String imagePath) async {
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('govid')
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    firebase_storage.UploadTask uploadTask =
        storageRef.putFile(File(imagePath));

    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  Future<String> uploadImageToFirebaseDTI(String imagePath) async {
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('govid')
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    firebase_storage.UploadTask uploadTask =
        storageRef.putFile(File(imagePath));

    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  Future<void> handlegovid() async {
    setState(() {
      isuploading = true;
    });
    try {
      if (xfiledti == null) {
        const SnackBar(
          content: Text("Please upload DTI permit"),
        );
        setState(() {
          isuploading = false;
        });
      } else if (xfilebir == null) {
        const SnackBar(
          content: Text("Please upload DTI permit"),
        );
        setState(() {
          isuploading = false;
        });
      } else {
        if (_formkey.currentState!.validate()) {
          String birpermit = await uploadImageToFirebaseBIR(xfilebir!.path);
          String dtipermit = await uploadImageToFirebaseDTI(xfiledti!.path);

          await usercred.doc(widget.documentID).update({
            "bir": birpermit,
            "dti": dtipermit,
            "tin": tinID.text
          }).then((value) {
            setState(() {
              isuploading = false;
            });
            debugPrint(widget.documentID);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VetCreds(documentID: widget.documentID)));
          });
        }
      }
    } catch (error) {
      const SnackBar(
        content: Text("Error uploading credentials"),
      );
    }
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
                isuploading == false
                    ? GlobalButton(
                        callback: () {
                          isuploading == false ? handlegovid() : null;
                        },
                        title: "Proceed")
                    : Center(
                        child: CircularProgressIndicator(
                          color: maincolor,
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
