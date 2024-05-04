import 'package:flutter/material.dart';
import 'package:ipet/controller/mapController.dart';
import 'package:ipet/utils/firebasehook.dart';

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
    return PopScope(
      onPopInvoked: (didpop) async {
        if (didpop) return;
        await deleteusermap();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: MappController(
          isclient: isclient,
          documentID: documentID,
          ishome: ishome,
        ),
      ),
    );
  }

  Future<void> deleteusermap() async {
    try {
      await usercred.doc(documentID).delete();
    } catch (e) {
      debugPrint("error deleting user");
    }
  }
}
