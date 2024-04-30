import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/utils/firebasehook.dart';
import 'package:location/location.dart';

class MappController extends StatefulWidget {
  final String documentID;
  const MappController({super.key, required this.documentID});

  @override
  State<MappController> createState() => _MappControllerState();
}

class _MappControllerState extends State<MappController> {
  String? latitude;
  String? longtitude;
  Location location = Location();
  bool _serviceEnabled = false;
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
    return Stack(
      children: [
        GoogleMap(
          onTap: _onMapTapped,
          markers: markers.values.toSet(),
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        Positioned(
            top: 20,
            left: 18,
            child: FloatingActionButton(
              backgroundColor: maincolor,
              onPressed: () {
                // getCurrentLocation();

                debugPrint("lat = $latitude \n long = $longtitude");
              },
              child: const Icon(
                Icons.my_location_outlined,
                color: Colors.white,
              ),
            )),
        if (latitude != null &&
            longtitude != null &&
            latitude!.isNotEmpty &&
            longtitude!.isNotEmpty)
          Positioned(
            bottom: 20,
            left: 18,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.70,
              height: 50,
              child: FloatingActionButton(
                backgroundColor: maincolor,
                onPressed: () {},
                child: const MainFont(
                  title: "Continue",
                  color: Colors.white,
                ),
              ),
            ),
          )
      ],
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

  Future<void> getCurrentLocation() async {
    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      } else {
        LocationData currentLocation = await location.getLocation();
        final LatLng currentLatLng =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _onMapTapped(currentLatLng);
      }
    } catch (error) {
      debugPrint("Error getting current location: $error");
    }
  }

  Future<void> updatelatlong() async {
    try {
      await usercred
          .doc(widget.documentID)
          .collection('vertirenary')
          .doc(widget.documentID)
          .update({"lat": latitude, "long"});
    } catch (error) {
      debugPrint("Error - $error");
    }
  }
}
