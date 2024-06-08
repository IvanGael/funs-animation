// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';

// class CircularRevealAnimation extends StatefulWidget {
//   const CircularRevealAnimation({super.key});

//   @override
//   _CircularRevealAnimationState createState() =>
//       _CircularRevealAnimationState();
// }

// class _CircularRevealAnimationState extends State<CircularRevealAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..addListener(() {
//         setState(() {});
//       });

//     _animation = Tween<double>(
//       begin: 0,
//       end: 40,
//     ).animate(_controller);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: CustomPaint(
//           painter: _CircularRevealPainter(
//             fraction: _animation.value,
//             color: Colors.indigoAccent,
//           ),
//           child: ElevatedButton(
//             onPressed: () {
//               if (_controller.status == AnimationStatus.completed) {
//                 _controller.reverse();
//                 setState(() {
                  
//                 });
//               } else {
//                 _controller.forward();
//                 setState(() {
                  
//                 });
//               }
//             },
//             child: const Text("Discover"),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

// class _CircularRevealPainter extends CustomPainter {
//   _CircularRevealPainter({
//     required this.fraction,
//     required this.color,
//   });

//   final double fraction;
//   final Color color;

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..color = color;

//     Offset center = Offset(size.width / 2, size.height / 2);
//     double radius = size.width * fraction;

//     canvas.drawCircle(center, radius, paint);
//   }

//   @override
//   bool shouldRepaint(_CircularRevealPainter oldDelegate) {
//     return oldDelegate.fraction != fraction;
//   }
// }





// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CircularRevealAnimation extends StatefulWidget {
  final ImageProvider image;
  final AnimationController controller;

  const CircularRevealAnimation({
    super.key,
    required this.image,
    required this.controller,
  });

  @override
  _CircularRevealAnimationState createState() =>
      _CircularRevealAnimationState();
}

class _CircularRevealAnimationState extends State<CircularRevealAnimation> {
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: _CircularRevealPainter(
          fraction: _animation.value,
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: widget.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularRevealPainter extends CustomPainter {
  _CircularRevealPainter({
    required this.fraction,
  });

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.indigoAccent
      ..blendMode = BlendMode.dstOut;

    Offset center = Offset(size.width / 4, size.height / 4);
    double radius = size.width * fraction;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_CircularRevealPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}


class CustomCarouselSliderWithRevealAnimationScreen extends StatelessWidget {
  const CustomCarouselSliderWithRevealAnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomCarouselSlider(
        images: [
          AssetImage('assets/nature.jpg'),
          AssetImage('assets/nature2.jpg'),
          AssetImage('assets/nature3.jpg'),
          AssetImage('assets/nature.jpg'),
          AssetImage('assets/nature3.jpg'),
          AssetImage('assets/nature3.jpg'),
          AssetImage('assets/nature2.jpg'),
          AssetImage('assets/nature3.jpg')
        ],
      ),
    );
  }
}


class CustomCarouselSlider extends StatefulWidget {
  final List<ImageProvider> images;

  const CustomCarouselSlider({super.key, required this.images});

  @override
  _CustomCarouselSliderState createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addStatusListener((status) {
        // if (status == AnimationStatus.completed) {
        //   setState(() {
        //     _currentIndex = (_currentIndex + 1) % widget.images.length;
        //     _controller.reverse();
        //   });
        // }
      });
    _controller.forward();
  }

  void _nextImage() {
    if (_controller.status == AnimationStatus.completed) {
      setState(() {
            _currentIndex = (_currentIndex + 1) % widget.images.length;
            _controller.forward();
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _nextImage,
        child: Stack(
          children: [
            CircularRevealAnimation(
              image: widget.images[_currentIndex],
              controller: _controller,
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Row(
                children: List.generate(widget.images.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.blue
                          : Colors.white,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
