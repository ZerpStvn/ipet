import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WebMapController extends StatefulWidget {
  const WebMapController({super.key});

  @override
  State<WebMapController> createState() => _WebMapControllerState();
}

class _WebMapControllerState extends State<WebMapController> {
  String? latitude;
  String? longtitude;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.720641, 122.553519),
    zoom: 12.9746,
  );

  final BitmapDescriptor customMarkerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onTap: _onMapTapped,
      markers: markers.values.toSet(),
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  Map<MarkerId, Marker> markers = {};
  void _onMapTapped(LatLng latLng) {
    setState(() {
      latitude = latLng.latitude.toString();
      longtitude = latLng.longitude.toString();
    });
    _addMarker(latLng);
  }

  Future<void> _addMarker(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    final MarkerId markerId =
        MarkerId('marker_${latLng.latitude}_${latLng.longitude}');
    final marker = Marker(
      markerId: MarkerId("$markerId"),
      position: LatLng(latLng.latitude, latLng.longitude),
      // infoWindow: InfoWindow(),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    setState(() {
      markers.clear();
    });
    setState(() {
      markers[markerId] = marker;
    });
    controller.animateCamera(CameraUpdate.newLatLng(latLng));
  }
}
