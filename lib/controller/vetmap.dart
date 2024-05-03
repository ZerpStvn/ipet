import 'package:flutter/material.dart';
import 'package:ipet/controller/mapController.dart';

class VetMapping extends StatelessWidget {
  final String documentID;
  final bool ishome;
  final bool isclient;
  const VetMapping(
      {super.key,
      required this.documentID,
      required this.ishome,
      required this.isclient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MappController(
        isclient: isclient,
        documentID: documentID,
        ishome: ishome,
      ),
    );
  }
}
