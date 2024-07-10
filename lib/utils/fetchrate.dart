import 'package:flutter/material.dart';
import 'package:ipet/misc/function.dart';
import 'package:ipet/misc/themestyle.dart';

class FetchpriceRate extends StatelessWidget {
  const FetchpriceRate({super.key, required this.documentID});
  final String documentID;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: calculatePriceRating(documentID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError || !snapshot.hasData) {
          return MainFont(
            title: "No Reviews",
            color: maincolor,
          );
        } else {
          return MainFont(
            title:
                "Reviews ${double.parse("${snapshot.data}").toStringAsFixed(1)}",
            color: maincolor,
          );
        }
      },
    );
  }
}

class FetchStaffRate extends StatelessWidget {
  const FetchStaffRate({super.key, required this.documentID});
  final String documentID;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: calculateStaffRating(documentID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError || !snapshot.hasData) {
          return MainFont(
            title: "No Reviews",
            color: maincolor,
          );
        } else {
          return MainFont(
            title:
                "Reviews ${double.parse("${snapshot.data}").toStringAsFixed(1)}",
            color: maincolor,
          );
        }
      },
    );
  }
}
