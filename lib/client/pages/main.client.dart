import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipet/client/pages/nearclinic.dart';
import 'package:ipet/client/widgets/Topprofile.dart';
import 'package:ipet/client/widgets/search.dart';
import 'package:ipet/client/widgets/services.dart';
import 'package:ipet/misc/function.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:provider/provider.dart';

class ManClientPage extends StatefulWidget {
  const ManClientPage({super.key});

  @override
  State<ManClientPage> createState() => _ManClientPageState();
}

class _ManClientPageState extends State<ManClientPage> {
  late Stream<QuerySnapshot> vetstream;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProviderClass>(context);

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopProfile(provider: provider),
          const SearchClient(),
          const ServicesOffered(),
          const NearClinicView(),
        ],
      ),
    );
  }
}
