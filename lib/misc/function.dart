// ignore_for_file: file_names

import 'dart:math' show cos, sqrt, sin, atan2, pi;

import 'package:cloud_firestore/cloud_firestore.dart';

String splitWords(String words) {
  List<String> wordList = words.split(RegExp(r'\s+'));
  String firstWord = wordList[0];
  String secondWord = wordList.skip(1).join(' ');

  return '$firstWord $secondWord';
}

List<Map<String, dynamic>> services = [
  {
    "name": "Vaccination",
    "image": "assets/services/service1.png",
    "con": "vaccination"
  },
  {
    "name": "Operation",
    "image": "assets/services/service2.png",
    "con": "operation"
  },
  {
    "name": "Grooming",
    "image": "assets/services/service3.png",
    "con": "grooming"
  }
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
  return radiusOfEarth * c;
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
    double distance = calculateDistance(userLat, userLon, vetLat, vetLon);
    if (distance <= maxRadius) {
      nearbyVets.add(vet);
    }
  }
  return nearbyVets;
}

bool hasClinicsWithinRadius(double userLat, double userLon, double maxRadius,
    List<DocumentSnapshot> vets) {
  for (var vet in vets) {
    double vetLat = double.parse("${vet['lat']}");
    double vetLon = double.parse("${vet['long']}");
    double distance = calculateDistance(userLat, userLon, vetLat, vetLon);
    if (distance <= maxRadius) {
      return true;
    }
  }
  return false;
}

List<String> accomodation = [
  " Extremely accommodating",
  "Very accommodating",
  "Moderately accommodating",
  "Somewhat accommodating",
  "Not accommodating",
  "Unaccommodating",
];
Future<double> calculateRating(String documentid) async {
  double totalRating = 0;
  int reviewCount = 0;
  CollectionReference ratingsCollection = FirebaseFirestore.instance
      .collection('ratings')
      .doc(documentid)
      .collection('reviews');

  QuerySnapshot querySnapshot = await ratingsCollection.get();

  for (int i = 0; i < querySnapshot.docs.length; i++) {
    Map<String, dynamic>? documentdata =
        querySnapshot.docs[i].data() as Map<String, dynamic>?;
    double rating = documentdata!['rates'] ?? 0;
    totalRating += rating;
    reviewCount++;
  }

  double averageRating = reviewCount > 0 ? totalRating / reviewCount : 0;

  return averageRating;
}

Future<double> calculateStaffRating(String documentid) async {
  double totalRating = 0;
  int reviewCount = 0;
  CollectionReference ratingsCollection = FirebaseFirestore.instance
      .collection('ratings')
      .doc(documentid)
      .collection('reviews');

  QuerySnapshot querySnapshot = await ratingsCollection.get();

  for (int i = 0; i < querySnapshot.docs.length; i++) {
    Map<String, dynamic>? documentdata =
        querySnapshot.docs[i].data() as Map<String, dynamic>?;
    double rating = documentdata!['staffrate'] ?? 0;
    totalRating += rating;
    reviewCount++;
  }

  double averageRating = reviewCount > 0 ? totalRating / reviewCount : 0;

  return averageRating;
}

Future<double> calculatePriceRating(String documentid) async {
  double totalRating = 0;
  int reviewCount = 0;
  CollectionReference ratingsCollection = FirebaseFirestore.instance
      .collection('ratings')
      .doc(documentid)
      .collection('reviews');

  QuerySnapshot querySnapshot = await ratingsCollection.get();

  for (int i = 0; i < querySnapshot.docs.length; i++) {
    Map<String, dynamic>? documentdata =
        querySnapshot.docs[i].data() as Map<String, dynamic>?;
    double rating = documentdata!['pricerate'] ?? 0;
    totalRating += rating;
    reviewCount++;
  }

  double averageRating = reviewCount > 0 ? totalRating / reviewCount : 0;

  return averageRating;
}

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}
