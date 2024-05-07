// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipet/client/controller/listofclinic.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:ipet/model/users.dart';
import 'package:provider/provider.dart';

class ClientMapWidget extends StatefulWidget {
  final AuthProviderClass provider;
  const ClientMapWidget({super.key, required this.provider});

  @override
  State<ClientMapWidget> createState() => _ClientMapWidgetState();
}

class _ClientMapWidgetState extends State<ClientMapWidget>
    with TickerProviderStateMixin {
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
  double aproximate = 10;
  late AnimationController _anicontroller;
  late Animation<double> _radiusAnimation;
  bool isradactive = false;
  double _currentSliderValue = 1;
  static const double initialRadius = 1000;
  double radiusinkm = 2000;
  late Future<Set<Marker>> _markersFuture;
  @override
  void initState() {
    super.initState();
    _markersFuture = createMarkers(widget.provider);
    _anicontroller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _radiusAnimation = Tween<double>(
      begin: initialRadius,
      end: initialRadius,
    ).animate(_anicontroller);
  }

  @override
  void dispose() {
    super.dispose();
    searchplace.dispose();
    _anicontroller.dispose();
  }

  void updateRadius(double newRadius) {
    _anicontroller.reset();
    _anicontroller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _radiusAnimation = Tween<double>(
      begin: _radiusAnimation.value,
      end: newRadius,
    ).animate(_anicontroller)
      ..addListener(() {
        setState(() {});
      });
    _anicontroller.forward();
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
      if (location["valid"] == 1) {
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
      } else {}
      // double distance = calculateDistance(
      //     userLat, userLon, location['lat'], location['long']);
      // if (distance <= aproximate) {
      //   if (location["valid"] == 1) {
      //     double lat = location['lat'];
      //     double lon = location['long'];
      //     String name = location['clinicname'];
      //     Marker vetMarker = Marker(
      //       markerId: MarkerId("location$lat"),
      //       position: LatLng(lat, lon),
      //       icon:
      //           BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      //       infoWindow: InfoWindow(title: name),
      //     );
      //     markers.add(vetMarker);
      //   } else {}
      // }
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
      int valid = doc['valid'];
      vetLocations.add({
        'id': doc.id,
        'lat': lat,
        'long': lon,
        'valid': valid,
        'clinicname': name,
      });
    }
    return vetLocations;
  }

  @override
  Widget build(BuildContext context) {
    double heightsize = MediaQuery.of(context).size.height;
    final AuthProviderClass provider = Provider.of<AuthProviderClass>(context);
    return SingleChildScrollView(
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 99,
            height: 699,
            child: FutureBuilder<Set<Marker>>(
              future: _markersFuture,
              builder:
                  (BuildContext context, AsyncSnapshot<Set<Marker>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
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
                    circles: {
                      Circle(
                        circleId: const CircleId('userCircle'),
                        center: LatLng(
                            double.parse("${provider.usermapping!.lat}"),
                            double.parse("${provider.usermapping!.long}")),
                        radius: _radiusAnimation.value,
                        fillColor: Colors.blue.withOpacity(0.3),
                        strokeWidth: 0,
                      ),
                    },
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
              top: 52,
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
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: TextFormField(
                            readOnly: true,
                            onTap: () {},
                            controller: searchplace,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: maincolor,
                              hintStyle: const TextStyle(color: Colors.white),
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
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isradactive = !isradactive;
                                });
                              },
                              icon: const Icon(
                                Icons.tune_outlined,
                                color: Colors.white,
                              )),
                        ),
                      )
                    ],
                  ))),

          isradactive == true
              ? Positioned(
                  top: 112,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: 150,
                    decoration: BoxDecoration(
                        color: maincolor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainFont(
                          title: "Distance ${radiusinkm ~/ 1000} Km",
                          fweight: FontWeight.bold,
                          color: Colors.white,
                          fsize: 20,
                        ),
                        const MainFont(
                          title:
                              "You Can adjust the distance of\nsearch to find more places",
                          color: Colors.white,
                          fsize: 12,
                        ),
                        Slider(
                          max: 100,
                          divisions: 100,
                          label:
                              '${(_currentSliderValue / 100 * 100).toStringAsFixed(1)} Km',
                          value: _currentSliderValue,
                          onChanged: (double value) {
                            _currentSliderValue = value;
                            setState(() {
                              double newRadius = value * 1000;
                              updateRadius(newRadius);
                              radiusinkm = newRadius;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),

          Positioned(
              bottom: heightsize >= 185 ? 30 : 90,
              child: DisplayListofClinic(
                provider: provider,
                maxRadius: radiusinkm,
              )),
        ],
      ),
    );
  }
}
