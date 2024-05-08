// ignore_for_file: prefer_collection_literals

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ipet/utils/env.dart';

class VetClinicUserClientPolyline extends StatefulWidget {
  final bool ispolyline;
  final double userLat;
  final double userLon;
  final double clinicLat;
  final double clinicLon;
  const VetClinicUserClientPolyline({
    super.key,
    required this.ispolyline,
    required this.userLat,
    required this.userLon,
    required this.clinicLat,
    required this.clinicLon,
  });

  @override
  State<VetClinicUserClientPolyline> createState() =>
      _VetClinicUserClientPolylineState();
}

class _VetClinicUserClientPolylineState
    extends State<VetClinicUserClientPolyline> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.720641, 122.553519),
    zoom: 13.9746,
  );

  late Set<Marker> _markers;
  late Set<Polyline> _polylines;

  @override
  void initState() {
    super.initState();
    _markers = Set<Marker>();
    _polylines = Set<Polyline>();
    _addMarkerAndPolyline();
  }

  void _addMarkerAndPolyline() async {
    // Add user marker
    _markers.add(
      Marker(
        markerId: const MarkerId('userMarker'),
        position: LatLng(widget.userLat, widget.userLon),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'User'),
      ),
    );
    //

    // Add clinic marker
    _markers.add(
      Marker(
        markerId: const MarkerId('clinicMarker'),
        position: LatLng(widget.clinicLat, widget.clinicLon),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        infoWindow: const InfoWindow(title: 'Clinic'),
      ),
    );

    // Fetch route polyline points
    List<LatLng> routePoints = await _getRoutePoints();
    if (routePoints.isNotEmpty) {
      // Add polyline
      Polyline polyline = Polyline(
        polylineId: const PolylineId('route'),
        points: routePoints,
        color: Colors.blue,
        width: 5,
      );
      setState(() {
        _polylines.add(polyline);
      });
    }
  }

  Future<List<LatLng>> _getRoutePoints() async {
    String apiKey = googleAPIkey; // Replace with your Google Directions API key
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.userLat},${widget.userLon}&destination=${widget.clinicLat},${widget.clinicLon}&key=$apiKey';
    List<LatLng> routePoints = [];

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> routes = jsonData['routes'];
        if (routes.isNotEmpty) {
          String pointsEncoded = routes[0]['overview_polyline']['points'];
          routePoints = _decodePolyline(pointsEncoded);
        }
      } else {
        throw Exception('Failed to load route');
      }
    } catch (e) {
      debugPrint('Error fetching route: $e');
    }

    return routePoints;
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      poly.add(LatLng(latitude, longitude));
    }
    return poly;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: _markers,
      polylines: _polylines,
    );
  }
}
