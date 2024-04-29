import 'package:flutter/material.dart';
import 'package:ipet/controller/selecttype.dart';
import 'package:ipet/misc/themestyle.dart';

class GloballoginController extends StatefulWidget {
  const GloballoginController({super.key});

  @override
  State<GloballoginController> createState() => _GloballoginControllerState();
}

class _GloballoginControllerState extends State<GloballoginController> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isobscure = true;

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 95,
                ),
                Text(
                  "Let's Sign you in.",
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
                  height: 15,
                ),
                const Text(
                  "Welcome to our platform! We're thrilled to have you here. To unlock all the features and resources available, please log in to your account.",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 75,
                ),
                const Text("Email address"),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 65,
                  child: TextFormField(
                    controller: email,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter valid email";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        hintText: "Enter Email Address",
                        suffix: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text("Email address"),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 65,
                  child: TextFormField(
                    obscureText: isobscure,
                    controller: password,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter your password";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        hintText: "Enter your password",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isobscure = !isobscure;
                            });
                          },
                          child: Icon(isobscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: const Text("Forgot password?")),
                    const SizedBox(
                      height: 5,
                    ),
                    GlobalButton(callback: () {}, title: "Login"),
                    Center(
                      child: TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectTypeUser())),
                          child:
                              const Text("Don't have and account ? Sign up")),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
