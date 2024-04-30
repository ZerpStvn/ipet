import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipet/controller/vetgov.dart';
import 'package:ipet/misc/formtext.dart';
import 'package:ipet/misc/themestyle.dart';

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
    nameofclinic.dispose();
    ownersfirstname.dispose();
    ownerslastname.dispose();
    phonenumber.dispose();
    emailaddress.dispose();
    password.dispose();
    cpassword.dispose();
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
            GlobalButton(
                callback: () {
                  uploadfirstcred();
                },
                title: "Proceed")
          ],
        ),
      ),
    );
  }

  Future<void> uploadfirstcred() async {
    try {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const VetGovController()));
      // if (_formkey.currentState!.validate()) {

      // }
    } catch (error) {}
  }
}
