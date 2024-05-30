// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';


class CustomKeyboardScreen extends StatelessWidget {
  const CustomKeyboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: KeyboardPage(),
      );
  }
}

class KeyboardPage extends StatefulWidget {
  const KeyboardPage({super.key});

  @override
  _KeyboardPageState createState() => _KeyboardPageState();
}

class _KeyboardPageState extends State<KeyboardPage> {
  List<String> keys = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: keys.length,
            itemBuilder: (context, index) {
              return DragTarget<String>(
                onAcceptWithDetails: (data) {
                  setState(() {
                    int oldIndex = keys.indexOf(data.data);
                    keys.removeAt(oldIndex);
                    keys.insert(index, data.data);
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return Draggable<String>(
                    data: keys[index],
                    feedback: KeyTile(keys[index], isDragging: true),
                    childWhenDragging: Container(),
                    child: KeyTile(keys[index]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class KeyTile extends StatefulWidget {
  final String keyLabel;
  final bool isDragging;

  const KeyTile(this.keyLabel, {super.key, this.isDragging = false});

  @override
  _KeyTileState createState() => _KeyTileState();
}

class _KeyTileState extends State<KeyTile> with SingleTickerProviderStateMixin {
  bool isPressed = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      isPressed = true;
      _controller.forward();
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      isPressed = false;
      _controller.reverse();
    });
  }

  void _onTapCancel() {
    setState(() {
      isPressed = false;
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: isPressed
            ? (Matrix4.identity()..scale(0.95))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: widget.isDragging ? Colors.grey : Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            if (!widget.isDragging)
              const BoxShadow(
                color: Colors.black26,
                offset: Offset(2, 2),
                blurRadius: 4.0,
              ),
          ],
        ),
        margin: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            widget.keyLabel,
            style: const TextStyle(color: Colors.white, fontSize: 24, decoration: TextDecoration.none),
          ),
        ),
      ),
    );
  }
}
