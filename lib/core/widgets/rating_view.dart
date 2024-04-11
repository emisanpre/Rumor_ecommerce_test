import 'package:flutter/material.dart';

class RatingView extends StatelessWidget {
  final double value;
  final int reviewsCount;

  const RatingView({
    super.key,
    required this.value,
    required this.reviewsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.star,
          color: Colors.amber,
          size: 20,
        ),
        const SizedBox(width: 4),
        Text(
          '$value',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 4),
        Text(
          '($reviewsCount reviews)',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}