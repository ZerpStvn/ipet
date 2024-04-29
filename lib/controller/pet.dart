import 'package:flutter/material.dart';

class PetController extends StatefulWidget {
  const PetController({super.key});

  @override
  State<PetController> createState() => _PetControllerState();
}

class _PetControllerState extends State<PetController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text("Pet Pwmer")],
    );
  }
}
