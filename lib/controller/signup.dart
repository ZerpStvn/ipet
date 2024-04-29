import 'package:flutter/material.dart';
import 'package:ipet/controller/pet.dart';
import 'package:ipet/controller/vet.dart';

class SignupController extends StatefulWidget {
  final bool isvet;
  const SignupController({super.key, required this.isvet});

  @override
  State<SignupController> createState() => _SignupControllerState();
}

class _SignupControllerState extends State<SignupController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.isvet ? const VetController() : const PetController()
          ],
        ),
      ),
    );
  }
}
