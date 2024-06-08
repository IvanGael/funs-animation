import 'dart:async';

import 'package:flutter/material.dart';

class ImageParallaxAnimation extends StatefulWidget {
  const ImageParallaxAnimation({super.key});

  @override
  State<ImageParallaxAnimation> createState() => _ImageParallaxAnimationState();
}

class _ImageParallaxAnimationState extends State<ImageParallaxAnimation> {
  late ScrollController _controller;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_controller.hasClients) {
        _controller.animateTo(
          _controller.offset + MediaQuery.of(context).size.height,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
              imageAsset: 'assets/manga4.jpg',
              speed: 0.2,
              controller: _controller,
            ),
            ParallaxLayer(
              imageAsset: 'assets/manga5.jpg',
              speed: 0.5,
              controller: _controller,
            ),
            ParallaxLayer(
              imageAsset: 'assets/manga6.png',
              speed: 0.8,
              controller: _controller,
            ),
            ParallaxLayer(
              imageAsset: 'assets/manga7.jpg',
              speed: 0.2,
              controller: _controller,
            ),
            ParallaxLayer(
              imageAsset: 'assets/manga8.jpg',
              speed: 0.8,
              controller: _controller,
            ),
            ParallaxLayer(
              imageAsset: 'assets/manga1.jpg',
              speed: 0.2,
              controller: _controller,
            ),
            ParallaxLayer(
              imageAsset: 'assets/manga9.jpg',
              speed: 0.8,
              controller: _controller,
            ),
            ParallaxLayer(
              imageAsset: 'assets/manga10.jpg',
              speed: 0.2,
              controller: _controller,
            ),
            ParallaxLayer(
              imageAsset: 'assets/manga2.jpg',
              speed: 0.5,
              controller: _controller,
            ),
            ParallaxLayer(
              imageAsset: 'assets/manga11.jpg',
              speed: 0.8,
              controller: _controller,
            ),
            ParallaxLayer(
              imageAsset: 'assets/manga12.jpg',
              speed: 0.8,
              controller: _controller,
            ),
            ParallaxLayer(
              imageAsset: 'assets/manga13.jpeg',
              speed: 0.8,
              controller: _controller,
            ),
            for(int i = 0; i<2; i++)
            ParallaxLayer(
              imageAsset: 'assets/manga14.jpeg',
              speed: 0.8,
              controller: _controller,
            ),
            for(int i = 0; i<1000; i++)
            ParallaxLayer(
              imageAsset: 'assets/manga11.jpg',
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

  const ParallaxLayer({
    super.key,
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
