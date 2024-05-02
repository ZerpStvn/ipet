import 'package:flutter/material.dart';
import 'package:ipet/controller/mapController.dart';

class VetMapping extends StatelessWidget {
  final String documentID;
  final bool ishome;
  const VetMapping({super.key, required this.documentID, required this.ishome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MappController(
        isclient: false,
        documentID: documentID,
        ishome: ishome,
      ),
    );
  }
}
