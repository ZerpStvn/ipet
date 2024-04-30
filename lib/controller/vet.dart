import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipet/controller/vetgov.dart';
import 'package:ipet/misc/formtext.dart';
import 'package:ipet/misc/snackbar.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/users.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:ipet/utils/characterID.dart';
import 'package:ipet/utils/firebasehook.dart';

class VetController extends StatefulWidget {
  const VetController({super.key});

  @override
  State<VetController> createState() => _VetControllerState();
}

class _VetControllerState extends State<VetController> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController nameofclinic = TextEditingController();
  final TextEditingController ownersfirstname = TextEditingController();
  final TextEditingController ownerslastname = TextEditingController();
  final TextEditingController phonenumber = TextEditingController();
  final TextEditingController emailaddress = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cpassword = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final UsersModel usersModel = UsersModel();
  XFile? xFile;
  bool isobscure = true;
  bool isconfirm = true;
  bool isuploading = false;
  String? imageprofile;

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
  void initState() {
    super.initState();
    generateRandomString();
  }

  @override
  void dispose() {
    super.dispose();
    nameofclinic.dispose();
    ownersfirstname.dispose();
    ownerslastname.dispose();
    phonenumber.dispose();
    emailaddress.dispose();
    password.dispose();
    cpassword.dispose();
  }

  Future<String> uploadImageToFirebase(String imagePath) async {
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('userprofile')
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    firebase_storage.UploadTask uploadTask =
        storageRef.putFile(File(imagePath));

    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  Future<void> handlecreateuser() async {
    usersModel.imageprofile = await uploadImageToFirebase(xFile!.path);
    usersModel.nameclinic = nameofclinic.text;
    usersModel.fname = ownersfirstname.text;
    usersModel.lname = ownerslastname.text;
    usersModel.pnum = phonenumber.text;
    usersModel.email = emailaddress.text;
    usersModel.pass = password.text;
    usersModel.role = 1;
    usersModel.vetid = userAuth.currentUser!.uid;
    await usercred
        .doc(userAuth.currentUser!.uid)
        .set(usersModel.usersModelmap())
        .then((value) => {
              setState(() {
                isuploading = false;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VetGovController(
                            documentID: userAuth.currentUser!.uid)));
              })
            });
  }

  Future<void> uploadfirstcred() async {
    setState(() {
      isuploading = true;
    });
    try {
      if (_formkey.currentState!.validate()) {
        if (xFile != null) {
          await userAuth
              .createUserWithEmailAndPassword(
                  email: emailaddress.text, password: password.text)
              .then((value) => handlecreateuser());
        } else {
          setState(() {
            imageprofile = "Add your profile picture";
            isuploading = false;
          });
        }
      } else {
        setState(() {
          isuploading = false;
        });
      }
    } on FirebaseException catch (e) {
      SnackbarMessage(
        message: "$e",
      );
      setState(() {
        isuploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Register Your Clinic with Us",
              style: TextStyle(
                  fontSize: 25, color: maincolor, fontWeight: FontWeight.bold),
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
            const Text(
              "Are you a veterinary clinic owner or manager looking to expand your reach and connect with a broader audience of pet owners?",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                pickimage();
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: xFile != null
                    ? BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(xFile!.path))))
                    : BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(width: 3, color: Colors.green),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/placeholder.png")),
                      ),
              ),
            ),
            MainFont(
              title: imageprofile ?? "",
              color: Colors.red,
            ),
            const SizedBox(
              height: 15,
            ),
            Textformtype(
                textEditingController: nameofclinic,
                uppertitle: "What's The Name of Your Clinic?",
                textvalidator: "Provide clinic name"),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                    child: Textformtype(
                        textEditingController: ownersfirstname,
                        uppertitle: "First Name",
                        textvalidator: "Enter first name")),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Textformtype(
                        textEditingController: ownerslastname,
                        uppertitle: "Last Name",
                        textvalidator: "Enter last name")),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Textformtype(
                textEditingController: phonenumber,
                uppertitle: "Phone Number",
                textvalidator: "Provide phone number"),
            const SizedBox(
              height: 15,
            ),
            Textformtype(
                textEditingController: emailaddress,
                uppertitle: "Email Address",
                textvalidator: "Provide valid email address"),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                    child: Textformtype(
                        isbscure: isobscure,
                        icons: GestureDetector(
                          onTap: () {
                            setState(() {
                              isobscure = !isobscure;
                            });
                          },
                          child: Icon(isobscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                        textEditingController: password,
                        uppertitle: "Password",
                        textvalidator: "Password")),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Textformtype(
                        isbscure: isconfirm,
                        icons: GestureDetector(
                          onTap: () {
                            setState(() {
                              isconfirm = !isconfirm;
                            });
                          },
                          child: Icon(isconfirm
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                        textEditingController: cpassword,
                        uppertitle: "Confirm Password",
                        textvalidator: "Confirm password")),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            isuploading == false
                ? GlobalButton(
                    callback: () {
                      isuploading == false ? uploadfirstcred() : null;
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
    );
  }
}
