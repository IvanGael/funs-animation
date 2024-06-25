// custom_scroll_indicator.dart
import 'package:flutter/material.dart';

class CustomScrollIndicator extends StatelessWidget {
  final ValueNotifier<double> scrollPercentage;
  final int itemCount;

  const CustomScrollIndicator({
    super.key,
    required this.scrollPercentage,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: scrollPercentage,
      builder: (context, value, child) {
        return Container(
          width: 25,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              itemCount,
              (index) => Container(
                width: index == (value * itemCount).floor() ? 15 : 8,
                height: index == (value * itemCount).floor() ? 15 : 8,
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == (value * itemCount).floor()
                      ? Colors.indigoAccent.shade700
                      : Colors.grey,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
