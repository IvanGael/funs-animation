// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:async';


class TextPuzzleAnimation extends StatefulWidget {
  const TextPuzzleAnimation({super.key});

  @override
  _TextPuzzleScreenState createState() => _TextPuzzleScreenState();
}

class _TextPuzzleScreenState extends State<TextPuzzleAnimation>
    with SingleTickerProviderStateMixin {
  static const String text = "Hello World!";
  late List<String> textParts;
  late List<String> erasedTextParts;
  bool isErased = false;

  @override
  void initState() {
    super.initState();
    _initializeTextParts();
  }

  void _initializeTextParts() {
    textParts = text.split('');
    erasedTextParts = List.from(textParts);
  }

  void _eraseText() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (erasedTextParts.isNotEmpty) {
        setState(() {
          erasedTextParts.removeLast();
        });
      } else {
        timer.cancel();
        setState(() {
          isErased = true;
        });
      }
    });
  }

  void _restoreText() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (erasedTextParts.length < textParts.length) {
        setState(() {
          erasedTextParts.add(textParts[erasedTextParts.length]);
        });
      } else {
        timer.cancel();
        setState(() {
          isErased = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              erasedTextParts.join(),
              style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isErased ? _restoreText : _eraseText,
              child: Text(isErased ? 'Restore Text' : 'Erase Text'),
            ),
          ],
        ),
      ),
    );
  }
}
