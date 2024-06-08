// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' as ui;


class ImagePuzzling extends StatefulWidget {
  const ImagePuzzling({super.key});

  @override
  _ImagePuzzleState createState() => _ImagePuzzleState();
}

class _ImagePuzzleState extends State<ImagePuzzling> {
  ui.Image? image;
  List<Rect> erasedRects = [];
  Timer? _restoreTimer;

  @override
  void initState() {
    super.initState();
    loadImage('assets/manga1.jpg').then((img) {
      setState(() {
        image = img;
      });
    });
  }

  Future<ui.Image> loadImage(String asset) async {
    Completer<ui.Image> completer = Completer();
    var img = AssetImage(asset);
    ImageStreamListener listener;
    ImageStream stream = img.resolve(ImageConfiguration.empty);
    listener = ImageStreamListener((ImageInfo frame, bool _) {
      completer.complete(frame.image);
      // stream.removeListener(listener);
    });
    stream.addListener(listener);
    return completer.future;
  }

  void erase(Rect rect) {
    setState(() {
      erasedRects.add(rect);
    });
  }

  void restoreImage() {
    _restoreTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (erasedRects.isEmpty) {
        timer.cancel();
      } else {
        setState(() {
          erasedRects.removeLast();
        });
      }
    });
  }

  @override
  void dispose() {
    _restoreTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Puzzle"),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: restoreImage,
          ),
        ],
      ),
      body: Center(
        child: image == null
            ? const CircularProgressIndicator()
            : GestureDetector(
                onPanUpdate: (details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final Offset localOffset = box.globalToLocal(details.globalPosition);
                  erase(Rect.fromCenter(center: localOffset, width: 20, height: 20));
                },
                child: CustomPaint(
                  size: Size(image!.width.toDouble(), image!.height.toDouble()),
                  painter: PuzzlePainter(image: image!, erasedRects: erasedRects),
                ),
              ),
      ),
    );
  }
}

class PuzzlePainter extends CustomPainter {
  final ui.Image image;
  final List<Rect> erasedRects;

  PuzzlePainter({required this.image, required this.erasedRects});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    canvas.drawImage(image, Offset.zero, paint);

    for (var rect in erasedRects) {
      paint.blendMode = BlendMode.clear;
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
