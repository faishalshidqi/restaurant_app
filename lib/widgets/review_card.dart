import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/customer_review.dart';

class ReviewCard extends StatelessWidget {
  final CustomerReview review;
  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text('${review.name}, ${review.date}'),
        subtitle: Text(review.review),
      ),
    );
  }
}
