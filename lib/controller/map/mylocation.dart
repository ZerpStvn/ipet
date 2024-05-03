import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:provider/provider.dart';

class MyLocation extends StatefulWidget {
  const MyLocation({
    super.key,
  });

  @override
  State<MyLocation> createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.720641, 122.553519),
    zoom: 13.9746,
  );

  final BitmapDescriptor customMarkerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

  @override
  void dispose() {
    super.dispose();
  }

  Set<Marker> markers = {};
  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<AuthProviderClass>(context);
    if (userAuth.veterinarymovel != null) {
      LatLng position = LatLng(double.parse("${userAuth.veterinarymovel!.lat}"),
          double.parse("${userAuth.veterinarymovel!.long}"));
      markers.add(
        Marker(
          markerId: const MarkerId("VeterinaryMarker"),
          position: position,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }
    return GoogleMap(
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      markers: markers,
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
