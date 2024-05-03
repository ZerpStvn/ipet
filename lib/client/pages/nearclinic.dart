import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipet/misc/function.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:provider/provider.dart';

class NearClinicView extends StatefulWidget {
  const NearClinicView({super.key});

  @override
  State<NearClinicView> createState() => _NearClinicViewState();
}

class _NearClinicViewState extends State<NearClinicView> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProviderClass>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MainFont(
              title: "Clinic Near You",
              fsize: 20,
              fweight: FontWeight.w500,
            ),
            Icon(Icons.location_on_outlined),
          ],
        ),
        // TextButton(
        //     onPressed: () {
        //       debugPrint(
        //           "user lat = ${provider.usermapping!.lat}\nuser long = ${provider.usermapping!.long}");
        //     },
        //     child: Text("show Loc")),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collectionGroup('vertirenary')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            double userLon = double.parse("${provider.usermapping!.long}");
            List<DocumentSnapshot> vetDocuments = snapshot.data!.docs;
            List<DocumentSnapshot> nearbyVets = filterVetsByProximity(
                userLat, userLon, maxRadius, vetDocuments);

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: nearbyVets.length,
              itemBuilder: (BuildContext context, int index) {
                var vet = nearbyVets[index];
                return ListTile(
                  title: Text(vet['dateestablished']),
                  subtitle: Text(
                    'Distance: ${calculateDistance(userLat, userLon, double.parse("${vet['lat']}"), double.parse("${vet['long']}")).toStringAsFixed(2)} km',
                  ),
                  // You can add more information or customize the ListTile as needed
                );
              },
            );
          },
        ),
      ],
    );
  }
}
