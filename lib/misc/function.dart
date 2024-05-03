// ignore_for_file: file_names

import 'dart:math' show cos, sqrt, sin, atan2, pi, pow;

import 'package:cloud_firestore/cloud_firestore.dart';

String splitWords(String words) {
  List<String> wordList = words.split(RegExp(r'\s+'));
  String firstWord = wordList[0];
  String secondWord = wordList.skip(1).join(' ');

  return '$firstWord $secondWord';
}

List<Map<String, dynamic>> services = [
  {"name": "Vaccination", "image": "assets/services/service1.png"},
  {"name": "Operation", "image": "assets/services/service2.png"},
  {"name": "Anti Gams", "image": "assets/services/service3.png"}
];

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double radiusOfEarth = 6371; // Earth's radius in km
  double dLat = _toRadians(lat2 - lat1);
  double dLon = _toRadians(lon2 - lon1);
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return radiusOfEarth * c; // Distance in km
}

double _toRadians(double degree) {
  return degree * (pi / 180);
}

List<DocumentSnapshot> filterVetsByProximity(double userLat, double userLon,
    double maxRadius, List<DocumentSnapshot> vets) {
  List<DocumentSnapshot> nearbyVets = [];
  for (var vet in vets) {
    double vetLat = double.parse("${vet['lat']}");
    double vetLon = double.parse("${vet['long']}");
    double distance =
        calculateDistance(userLat, userLon, vetLat, vetLon); // Distance in km
    if (distance <= maxRadius) {
      nearbyVets.add(vet);
    }
  }
  return nearbyVets;
}
