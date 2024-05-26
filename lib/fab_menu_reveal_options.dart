// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';


class FabMenuRevealOptions extends StatefulWidget {
  const FabMenuRevealOptions({super.key});

  @override
  _FabMenuState createState() => _FabMenuState();
}

class _FabMenuState extends State<FabMenuRevealOptions> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAB Menu'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleMenu,
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animation,
        ),
      ),
      body: Container(
        alignment: Alignment.topRight,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isMenuOpen ? 200 : 0,
          width: _isMenuOpen ? 200 : 0,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(_isMenuOpen ? 20 : 0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.red,
                child: const Icon(Icons.add),
              ),
              FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.green,
                child: const Icon(Icons.remove),
              ),
              FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.yellow,
                child: const Icon(Icons.edit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
