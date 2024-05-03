import 'package:flutter/material.dart';
import 'package:ipet/misc/themestyle.dart';

class SearchClient extends StatelessWidget {
  const SearchClient({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 38.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
            color: const Color.fromARGB(31, 158, 158, 158),
            borderRadius: BorderRadius.circular(10)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.search_outlined,
                  color: Color.fromARGB(136, 158, 158, 158),
                ),
                SizedBox(
                  width: 10,
                ),
                MainFont(
                  title: "Search here..",
                  color: Color.fromARGB(136, 158, 158, 158),
                )
              ],
            ),
            Icon(
              Icons.tune_outlined,
              color: Color.fromARGB(136, 158, 158, 158),
            )
          ],
        ),
      ),
    );
  }
}
