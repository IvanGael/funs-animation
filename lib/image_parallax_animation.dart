import 'package:flutter/material.dart';


class ImageParallaxAnimation extends StatelessWidget {
  final ScrollController _controller = ScrollController();

  ImageParallaxAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: [
            ParallaxLayer(
              imageAsset: 'assets/manga1.jpg',
              speed: 0.2,
              controller: _controller,
            ),
            ParallaxLayer(
              imageAsset: 'assets/manga2.jpg',
              speed: 0.5,
              controller: _controller,
            ),
            ParallaxLayer(
              imageAsset: 'assets/manga3.jpg',
              speed: 0.8,
              controller: _controller,
            ),
            const SizedBox(height: 1000), // Ensures enough space for scrolling
          ],
        ),
      ),
    );
  }
}

class ParallaxLayer extends StatelessWidget {
  final String imageAsset;
  final double speed;
  final ScrollController controller;

  const ParallaxLayer({super.key, 
    required this.imageAsset,
    required this.speed,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              alignment: Alignment(
                2 * controller.offset * speed,
                0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
