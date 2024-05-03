// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    zoom: 12.9746,
  );
  final BitmapDescriptor customMarkerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

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
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProviderClass>(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 99,
      height: 699,
      child: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            bottom: 90,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 89,
              height: 150,
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collectionGroup('vertirenary')
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  double userLat = double.parse("${provider.usermapping!.lat}");
                  double maxRadius = 10;
                  double userLon =
                      double.parse("${provider.usermapping!.long}");
                  List<DocumentSnapshot> vetDocuments = snapshot.data!.docs;
                  List<DocumentSnapshot> nearbyVets = filterVetsByProximity(
                      userLat, userLon, maxRadius, vetDocuments);

                  return ListView.builder(
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: nearbyVets.length,
                    itemBuilder: (BuildContext context, int index) {
                      var vet = nearbyVets[index];
                      return SizedBox(
                          width: 310,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, left: 9.0),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 9.0),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                children: [
                                  const MainFont(
                                      title: "Mediteranian Clinic Vet fur"),
                                  MainFont(
                                      title:
                                          "'Distance: ${calculateDistance(userLat, userLon, double.parse("${vet['lat']}"), double.parse("${vet['long']}")).toStringAsFixed(2)} km',")
                                ],
                              ),
                            ),
                          )

                          // You can add more information or customize the ListTile as needed

                          );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
