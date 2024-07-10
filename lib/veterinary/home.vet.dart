import 'package:flutter/material.dart';
import 'package:ipet/controller/map/mylocation.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:ipet/veterinary/pages/appointment.dart';
import 'package:ipet/veterinary/pages/main.home.dart';
import 'package:ipet/veterinary/pages/profilevet.dart';

class HomeScreenVeterinary extends StatefulWidget {
  const HomeScreenVeterinary({super.key});

  @override
  State<HomeScreenVeterinary> createState() => _HomeScreenVeterinaryState();
}

class _HomeScreenVeterinaryState extends State<HomeScreenVeterinary> {
  int _selectedIndex = 0;

  Widget navindex() {
    if (_selectedIndex == 0) {
      return const MainHomeVet();
    } else if (_selectedIndex == 1) {
      return const AppointmentVet();
    } else if (_selectedIndex == 2) {
      return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.83,
          child: const MyLocation());
    } else if (_selectedIndex == 3) {
      return const VeterinaryProfile();
    } else {
      return const MainHomeVet();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [navindex()],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: maincolor,
        surfaceTintColor: maincolor,
        child: SizedBox(
          height: 56,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconBottomBar(
                    text: "Home",
                    icon: Icons.home,
                    selected: _selectedIndex == 0,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    }),
                IconBottomBar(
                    text: "Appoint..",
                    icon: Icons.calendar_month_outlined,
                    selected: _selectedIndex == 1,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    }),
                IconBottomBar(
                    text: "Map",
                    icon: Icons.map,
                    selected: _selectedIndex == 2,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    }),
                IconBottomBar(
                    text: "Profile",
                    icon: Icons.person,
                    selected: _selectedIndex == 3,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 3;
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IconBottomBar extends StatelessWidget {
  const IconBottomBar(
      {super.key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed});
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 14, height: .1, color: Colors.white),
        )
      ],
    );
  }
}
