import 'package:flutter/material.dart';
import 'package:ipet/client/pages/service/serviceswidget.dart';
import 'package:ipet/misc/function.dart';
import 'package:ipet/misc/themestyle.dart';

class ServicesOffered extends StatelessWidget {
  const ServicesOffered({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 40),
          child: MainFont(
            title: "Services",
            fsize: 18,
          ),
        ),
        SizedBox(
          height: 180,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:
                services.length, // What is services? You need to define it.
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ServicesCategory(
                              servicecat: "${services[index]["con"]}")));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("${services[index]["image"]}")),
                          color: const Color.fromARGB(68, 151, 151, 151),
                        ),
                      ),
                      MainFont(title: "${services[index]["name"]}")
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
