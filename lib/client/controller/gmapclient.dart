import 'package:flutter/material.dart';
import 'package:ipet/controller/mapController.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:provider/provider.dart';

class ClientMapController extends StatelessWidget {
  const ClientMapController({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProviderClass>(context);
    return MappController(
      isclient: true,
      ishome: true,
      documentID: "${provider.userModel!.vetid}",
    );
  }
}
