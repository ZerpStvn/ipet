import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipet/client/widgets/eventview.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:provider/provider.dart';

class CardListView extends StatelessWidget {
  const CardListView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProviderClass>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, right: 25.0, bottom: 15.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 170,
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('appointment')
                .doc(provider.userModel!.vetid)
                .collection('vet')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: maincolor,
                  ),
                );
              } else if (!snapshot.hasData) {
                return const MainFont(title: "No Scheduled Appointments");
              } else {
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var datafetch = snapshot.data!.docs[index].data();
                      var getid = snapshot.data!.docs[index].id;
                      Timestamp timestamp =
                          datafetch['appoinmentdate'] ?? Timestamp.now();
                      DateTime dateTime = timestamp.toDate();
                      String formattedDate =
                          DateFormat('MMMM dd, yyyy h:mm a').format(dateTime);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventViewFormat(
                                        istitle: false,
                                        vetid: getid,
                                        isadmin: true,
                                      )));
                        },
                        child: CardView("${datafetch['name']}",
                            "${datafetch['profile']}", formattedDate),
                      );
                    });
              }
            }),
      ),
    );
  }
}

class CardView extends StatelessWidget {
  final String text;
  final String imageUrl;
  final String subtitle;

  const CardView(this.text, this.imageUrl, this.subtitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, bottom: 15),
      child: Container(
        width: 150,
        height: 150,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.5),
          boxShadow: [
            BoxShadow(
                offset: const Offset(10, 20),
                blurRadius: 10,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.05)),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(imageUrl), fit: BoxFit.cover)),
            ),
            const Spacer(),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            const SizedBox(
              height: 5,
            ),
            MainFont(
              title: subtitle,
              align: TextAlign.center,
              color: Colors.grey,
              fweight: FontWeight.normal,
              fsize: 12,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
