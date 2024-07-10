import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ipet/misc/themestyle.dart';

class Ratingsreview extends StatelessWidget {
  const Ratingsreview({
    super.key,
    required this.ratings,
  });

  final Function(double) ratings;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: RatingBar.builder(
        initialRating: 0,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          size: 14,
          color: maincolor,
        ),
        onRatingUpdate: (rating) {
          ratings(rating);
        },
      ),
    );
  }
}
