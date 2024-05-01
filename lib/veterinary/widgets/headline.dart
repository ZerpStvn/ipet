import 'package:flutter/material.dart';
import 'package:ipet/controller/vetgov.dart';
import 'package:ipet/controller/vetmap.dart';
import 'package:ipet/misc/themestyle.dart';

class PromoCard extends StatefulWidget {
  final String tin;
  final String dti;
  final String bir;
  final String documentID;
  final int status;
  final String lat;
  final String long;
  const PromoCard(
      {super.key,
      required this.tin,
      required this.dti,
      required this.bir,
      required this.documentID,
      required this.status,
      required this.lat,
      required this.long});

  @override
  State<PromoCard> createState() => _PromoCardState();
}

class _PromoCardState extends State<PromoCard> {
  Widget checkdocuments() {
    if (widget.tin.isEmpty || widget.bir.isEmpty || widget.dti.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Complete your\nbusiness documents",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: maincolor),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VetGovController(
                                documentID: widget.documentID,
                                ishome: true,
                              )));
                },
                child: const MainFont(
                  title: "Continue",
                  color: Colors.white,
                ))
          ],
        ),
      );
    } else if (widget.lat.isEmpty || widget.long.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Hi! Where are your\nClinic Located?",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: maincolor),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VetMapping(
                                documentID: widget.documentID,
                                ishome: true,
                              )));
                },
                child: const MainFont(
                  title: "Continue",
                  color: Colors.white,
                ))
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              "We're happy to be part\nof your lovely fur family",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: maincolor),
                onPressed: () {
                  null;
                },
                child: MainFont(
                  title: widget.status == 1 ? "Verified" : "Reviewing",
                  color: Colors.white,
                ))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
                colors: [Color(0xff53E88B), Color(0xff15BE77)])),
        child: Stack(
          children: [
            Opacity(
              opacity: .5,
              child: Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/BACKGROUND%202.png?alt=media&token=0d003860-ba2f-4782-a5ee-5d5684cdc244",
                  fit: BoxFit.cover),
            ),
            Positioned(
                bottom: 20,
                child: SizedBox(
                    width: 150, child: Image.asset("assets/documents.png"))),
            Align(alignment: Alignment.topRight, child: checkdocuments()),
          ],
        ),
      ),
    );
  }
}
