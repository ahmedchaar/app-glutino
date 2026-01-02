import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 14,
    this.color = const Color(0xFFFFC107), // Amber
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, size: size, color: color);
        } else if (index < rating && (rating - index) >= 0.5) {
           return Icon(Icons.star_half, size: size, color: color);
        } else {
           return Icon(Icons.star_border, size: size, color: Colors.grey[300]);
        }
      }),
    );
  }
}
