import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipet/client/pages/clinicsingleview.dart';
import 'package:ipet/client/pages/listofveterinary.dart';
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const MainFont(
              title: "Clinic Near You",
              fsize: 20,
              fweight: FontWeight.w500,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListofVeterinary()));
                },
                child: const Icon(Icons.location_on_outlined)),
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
              .limit(4)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error, Unable to load Data'),
              );
            }

            double userLat = double.parse("${provider.usermapping!.lat}");
            double maxRadius = 10;
            double userLon = double.parse("${provider.usermapping!.long}");
            List<DocumentSnapshot> vetDocuments = snapshot.data!.docs;
            List<DocumentSnapshot> nearbyVets = filterVetsByProximity(
                userLat, userLon, maxRadius, vetDocuments);

            return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: nearbyVets.length,
              itemBuilder: (BuildContext context, int index) {
                var vet = nearbyVets[index];
                String vetID = vet.id;
                if (vet['valid'] == 1) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ClinicViewSingle(documentID: vetID)));
                    },
                    leading: Container(
                      height: 60,
                      width: 80,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(80, 158, 158, 158),
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage("${vet['imageprofile']}"))),
                    ),
                    title: MainFont(title: "${vet['clinicname']}"),
                    subtitle: Text(
                      'Distance: ${calculateDistance(userLat, userLon, double.parse("${vet['lat']}"), double.parse("${vet['long']}")).toStringAsFixed(2)} km',
                    ),

                    // You can add more information or customize the ListTile as needed
                  );
                } else {
                  return Container();
                }
              },
            );
          },
        ),
      ],
    );
  }
}
