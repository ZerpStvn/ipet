// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipet/client/controller/listofclinic.dart';
import 'package:ipet/misc/function.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:ipet/model/users.dart';
import 'package:provider/provider.dart';

class ClientMapWidget extends StatefulWidget {
  const ClientMapWidget({super.key});

  @override
  State<ClientMapWidget> createState() => _ClientMapWidgetState();
}

class _ClientMapWidgetState extends State<ClientMapWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final UsersModel usersModel = UsersModel();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.720641, 122.553519),
    zoom: 14.2746,
  );
  final BitmapDescriptor customMarkerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  final TextEditingController searchplace = TextEditingController();
  String? clinicname;
  String? imageprofile;
  String? vetidl;
  String? datestablished;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchplace.dispose();
  }

  Future<Set<Marker>> createMarkers(AuthProviderClass provider) async {
    Set<Marker> markers = {};

    // Add marker for user's location
    double userLat = double.parse("${provider.usermapping!.lat}");
    double userLon = double.parse("${provider.usermapping!.long}");
    Marker userMarker = Marker(
      markerId: const MarkerId('user'),
      position: LatLng(userLat, userLon),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: const InfoWindow(title: 'User Location'),
    );
    markers.add(userMarker);
    List<Map<String, dynamic>> vetLocations = await getVetLocations();

    for (var location in vetLocations) {
      double lat = location['lat'];
      double lon = location['long'];
      String name = location['clinicname'];
      Marker vetMarker = Marker(
        markerId: MarkerId("location$lat"),
        position: LatLng(lat, lon),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        infoWindow: InfoWindow(title: name),
      );
      markers.add(vetMarker);
    }

    return markers;
  }

  Future<List<Map<String, dynamic>>> getVetLocations() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collectionGroup('vertirenary').get();
    List<Map<String, dynamic>> vetLocations = [];

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var doc = querySnapshot.docs[i];
      double lat = double.parse(doc['lat']);
      double lon = double.parse(doc['long']);
      String name = doc['clinicname'];
      vetLocations.add({
        'id': doc.id,
        'lat': lat,
        'long': lon,
        'clinicname': name,
      });
    }
    return vetLocations;
  }

  @override
  Widget build(BuildContext context) {
    final AuthProviderClass provider = Provider.of<AuthProviderClass>(context);
    return SingleChildScrollView(
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 99,
            height: 699,
            child: FutureBuilder<Set<Marker>>(
              future: createMarkers(provider),
              builder:
                  (BuildContext context, AsyncSnapshot<Set<Marker>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(); // Or any loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return GoogleMap(
                    zoomControlsEnabled: false,
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      if (!_controller.isCompleted) {
                        _controller.complete(controller);
                      }
                    },
                    markers: snapshot.data!,
                  );
                }
              },
            ),
          ),

          // SizedBox(
          //   width: MediaQuery.of(context).size.width * 99,
          //   height: 699,
          //   child: GoogleMap(
          //     zoomControlsEnabled: false,
          //     mapType: MapType.normal,
          //     initialCameraPosition: _kGooglePlex,
          //     onMapCreated: (GoogleMapController controller) {
          //       _controller.complete(controller);
          //     },
          //     markers: createMarkers(provider),
          //   ),
          // ),
          Positioned(
              top: 12,
              left: 10,
              right: 10,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: searchplace,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: maincolor,
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: "Search..",
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 9,
                      ),
                      Expanded(
                        flex: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: maincolor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.tune_outlined,
                                color: Colors.white,
                              )),
                        ),
                      )
                    ],
                  ))),
          Positioned(
              bottom: 90, child: DisplayListofClinic(provider: provider)),
        ],
      ),
    );
  }
}
