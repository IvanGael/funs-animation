// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';


class RatingStarsAnimation extends StatefulWidget {
  const RatingStarsAnimation({super.key});

  @override
  _RatingStarsState createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStarsAnimation> {
  int rating = 0;

  void updateRating(int newRating) {
    setState(() {
      rating = newRating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                updateRating(index + 1);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.all(8.0),
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < rating
                      ? Colors.amber // Filled star color
                      : Colors.grey[400], // Empty star color
                ),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: index < rating ? 1.0 : 0.0,
                  child: const Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
