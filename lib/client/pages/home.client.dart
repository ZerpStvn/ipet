import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ipet/client/widgets/clientHomeWidget.dart';
import 'package:ipet/client/widgets/clientMapWidget.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:provider/provider.dart';

class HomeClientMain extends StatefulWidget {
  const HomeClientMain({super.key});

  @override
  State<HomeClientMain> createState() => _HomeClientMainState();
}

class _HomeClientMainState extends State<HomeClientMain> {
  int _atpage = 2;

  Widget pagerender() {
    final provider = Provider.of<AuthProviderClass>(context);
    if (_atpage == 0) {
      return ClientHomeWidget(provider: provider);
    } else if (_atpage == 2) {
      return const ClientMapWidget();
    }
    return ClientHomeWidget(provider: provider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 65,
            ),
            pagerender()
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _atpage,
        backgroundColor: _atpage == 2 ? Colors.transparent : Colors.white,
        color: maincolor,
        onTap: (value) {
          setState(() {
            _atpage = value;
            debugPrint("$_atpage");
          });
        },
        items: const [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.calendar_month,
            color: Colors.white,
          ),
          Icon(
            Icons.location_on,
            color: Colors.white,
          ),
          Icon(
            Icons.shopping_bag,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
