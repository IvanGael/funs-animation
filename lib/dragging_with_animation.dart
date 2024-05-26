// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';


class DraggingWithAnimation extends StatefulWidget {
  const DraggingWithAnimation({super.key});

  @override
  _DraggableWidgetDemoState createState() => _DraggableWidgetDemoState();
}

class _DraggableWidgetDemoState extends State<DraggingWithAnimation> {
  Offset position = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Draggable(
              feedback: Container(
                width: 100,
                height: 100,
                color: Colors.blue.withOpacity(0.5),
                child: const Center(
                  child: Text(
                    'Dragging...',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              onDraggableCanceled: (velocity, offset) {
                setState(() {
                  position = offset;
                });
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: const Center(
                  child: Text(
                    'Drag me!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
