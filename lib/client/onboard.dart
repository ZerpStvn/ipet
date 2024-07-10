import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ipet/controller/login.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late SharedPreferences pref;
  List<Map<String, dynamic>> imageonboard = [
    {
      "assets": "assets/booking.png",
      "heading": "Your Trusted Veterinary",
      "text":
          "When it comes to the health and well-being of your beloved pets, you deserve nothing but the best."
    },
    {
      "assets": "assets/Share_location.png",
      "heading": "Find the Nearest Veterinary Clinic",
      "text":
          "Locating the nearest veterinary clinic is crucial for prompt and efficient care for your furry companions. "
    },
  ];
  int _currentIndex = 0;

  Future<void> saveonboarding() async {
    pref = await SharedPreferences.getInstance();
    pref.setBool("onboard", true);
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.location,
      Permission.locationWhenInUse,
      Permission.storage,
    ].request();

    statuses.forEach((permission, status) {
      if (!status.isGranted && !status.isPermanentlyDenied) {
        permission.request();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 190,
            ),
            Center(
              child: CarouselSlider(
                items: imageonboard.map((items) {
                  return SizedBox(
                    width: 280,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 210,
                          child: Image.asset(
                            "${items['assets']}",
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "${items['heading']}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "${items['text']}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 14),
                        )
                      ],
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                    height: 440,
                    enableInfiniteScroll: false,
                    autoPlay: false,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    pauseAutoPlayOnTouch: true,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageonboard.map((imagePath) {
                int index = imageonboard.indexOf(imagePath);
                return Container(
                  width: 10,
                  height: 10,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? maincolor : Colors.grey,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GlobalButton(
                  callback: () {
                    saveonboarding().then((value) =>
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const GloballoginController()),
                            (route) => false));
                  },
                  title: _currentIndex == 1 ? "Skip" : "Continue"),
            )
          ],
        ),
      ),
    );
  }
}
