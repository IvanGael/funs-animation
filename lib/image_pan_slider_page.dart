// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ImagePanSliderPage extends StatefulWidget {
  const ImagePanSliderPage({super.key});

  @override
  _ImagePanSliderPageState createState() => _ImagePanSliderPageState();
}

class _ImagePanSliderPageState extends State<ImagePanSliderPage> {
  double _currentSliderValue = 0;
  final TransformationController _controller = TransformationController();
  final double _imageWidth = 800.0; 
  final double _viewportWidth = 400.0; 

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateSliderValue);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateSliderValue);
    _controller.dispose();
    super.dispose();
  }

  void _updateSliderValue() {
    final translation = _controller.value.getTranslation();
    setState(() {
      // Calculate slider value based on image translation and width
      _currentSliderValue = -translation.x / (_imageWidth - _viewportWidth);
      // Clamp the value between 0 and 1
      _currentSliderValue = _currentSliderValue.clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: InteractiveViewer(
              transformationController: _controller,
              constrained: false,
              child: Image.asset('assets/nature5.jpg', width: _imageWidth),
            ),
          ),
          const Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Matej Hrescak",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "Our view from the mountains today",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13
                    ),
                  )
                ],
              ),
            )
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: _currentSliderValue * (MediaQuery.of(context).size.width - 40), // Subtract 40 to account for padding
                      child: Container(
                        width: 70,
                        height: 6,
                        decoration:  BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)
                          // shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
