import 'package:flutter/material.dart';
import 'package:ipet/controller/mapController.dart';

class VetMapping extends StatefulWidget {
  final String documentID;
  const VetMapping({super.key, required this.documentID});

  @override
  State<VetMapping> createState() => _VetMappingState();
}

class _VetMappingState extends State<VetMapping> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MappController(),
    );
  }
}
