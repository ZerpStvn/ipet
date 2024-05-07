import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipet/client/pages/clinicsingleview.dart';
import 'package:ipet/misc/function.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:provider/provider.dart';

class ListofVeterinary extends StatefulWidget {
  const ListofVeterinary({super.key});

  @override
  State<ListofVeterinary> createState() => _ListofVeterinaryState();
}

class _ListofVeterinaryState extends State<ListofVeterinary> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProviderClass>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const MainFont(
          title: "Clinic",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collectionGroup('vertirenary')
                  .limit(4)
                  .snapshots(),
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
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
