import 'package:flutter/material.dart';
import 'package:ipet/controller/login.dart';
import 'package:ipet/controller/mapController.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/utils/firebasehook.dart';
import 'package:ipet/utils/signup_aler.dart';

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
      canPop: false,
      onPopInvoked: (didpop) async {
        if (didpop) return;
        handlenotcontinue(context, () {
          deleteusermap(context);
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: MainFont(
            title: "Mark your Location",
          ),
        ),
        body: MappController(
          isclient: isclient,
          documentID: documentID,
          ishome: ishome,
        ),
      ),
    );
  }

  Future<void> deleteusermap(BuildContext context) async {
    try {
      await userAuth.currentUser!.delete();
      await usercred.doc(documentID).delete().then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const GloballoginController()),
            (route) => false);
      });
    } catch (e) {
      debugPrint("error deleting user");
    }
  }
}
