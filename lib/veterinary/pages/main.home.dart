import 'package:flutter/material.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:ipet/veterinary/widgets/cardlist.dart';
import 'package:ipet/veterinary/widgets/headline.dart';
import 'package:ipet/veterinary/widgets/rheadline.dart';
import 'package:ipet/veterinary/widgets/sheadline.dart';
import 'package:ipet/veterinary/widgets/topbar.dart';
import 'package:provider/provider.dart';

class MainHomeVet extends StatelessWidget {
  const MainHomeVet({super.key});

  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProviderClass>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TopBar(),
        PromoCard(
          tin: "${authprovider.veterinarymovel!.tin}",
          dti: "${authprovider.veterinarymovel!.dti}",
          bir: "${authprovider.veterinarymovel!.bir}",
          documentID: "${authprovider.userModel!.vetid}",
          status: authprovider.veterinarymovel!.valid ?? 1,
          lat: "${authprovider.veterinarymovel!.lat}",
          long: "${authprovider.veterinarymovel!.long}",
        ),
        const SizedBox(
          height: 30,
        ),
        const Headline(),
        const CardListView(),
        const SHeadline(),
      ],
    );
  }
}
