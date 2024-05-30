// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';


class RipplePainter extends CustomPainter {
  final Animation<double> animation;
  final Offset tapPosition;

  RipplePainter({required this.animation, required this.tapPosition}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.blue.withOpacity(0.5 * (1 - animation.value));

    canvas.drawCircle(tapPosition, animation.value * size.width * 0.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class VirtualAquarium extends StatefulWidget {
  const VirtualAquarium({super.key});

  @override
  _AquariumScreenState createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<VirtualAquarium> with SingleTickerProviderStateMixin {
  List<Widget> fishWidgets = [];
  List<Widget> decorationWidgets = [];

  final TransformationController _controller = TransformationController();

  List<String> aquaBgs = [
    'assets/aquarium_background.jpg',
    'assets/aquarium_background2.jpg',
    // 'assets/aquarium_background3.jpg'
  ];
  int aquaBgCurrentIndex = 0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Offset _tapPosition;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _pulseAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeOut,
      ),
    )..addListener(() {
      setState(() {});
    });

    _pulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.reset();
      }
    });

    _tapPosition = const Offset(0, 0);

    _initializeAquarium();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startPloofAnimation(Offset position) {
    setState(() {
      _tapPosition = position;
    });
    _pulseController.forward();
  }

  void _initializeAquarium() {
    _scheduleFishAdding();
  }

  void _scheduleFishAdding() {
    Timer.periodic(const Duration(seconds: 4), (timer) {
      Future.delayed(const Duration(seconds: 3), () {
        _addNewFish();
      });
      Future.delayed(const Duration(seconds: 6), () {
        setState(() {
          aquaBgCurrentIndex = Random().nextInt(aquaBgs.length);
        });
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final bg in aquaBgs) {
      precacheImage(AssetImage(bg), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) {
          _startPloofAnimation(details.globalPosition);
        },
        child: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _controller,
              constrained: false,
              child: Image.asset(aquaBgs[0], fit: BoxFit.cover),
            ),
          ),
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/aquarium_background.jpg',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          ...decorationWidgets,
          ...fishWidgets,
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: CustomPaint(
            size: Size.infinite,
            painter: RipplePainter(animation: _pulseAnimation, tapPosition: _tapPosition),
          )
          ),
        ],
      )
      ),
    );
  }

  void _addNewFish() {
    setState(() {
      fishWidgets.add(const SwimmingFish());
    });
  }
}


class SwimmingFish extends StatefulWidget {
  const SwimmingFish({super.key});

  @override
  _SwimmingFishState createState() => _SwimmingFishState();
}

class _SwimmingFishState extends State<SwimmingFish> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double verticalPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    verticalPosition = 200 + Random().nextInt(350).toDouble(); 

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    _animation = Tween<double>(
      begin: -100, // start off the screen to the left
      end: screenWidth + 100, // end off the screen to the right
    ).animate(_controller);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: _animation.value,
          top: verticalPosition,
          child: const FishWidget(),
        );
      },
    );
  }
}

class FishWidget extends StatefulWidget {
  const FishWidget({super.key});

  @override
  State<FishWidget> createState() => _FishWidgetState();
}

class _FishWidgetState extends State<FishWidget> {
  List<String> fishes = [
    "assets/fish.png",
    "assets/fish2.png",
    "assets/fish3.png",
    "assets/fish4.png",
    // "assets/fish5.png",
    // "assets/fish6.png",
    // "assets/fish7.png",
    // "assets/fish8.png",
    "assets/fish9.png",
    "assets/fish10.png"
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 80,
      child: Image.asset(fishes[Random().nextInt(fishes.length)]),
    );
  }
}
