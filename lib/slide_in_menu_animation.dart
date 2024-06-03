// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';


class SlideInMenuAnimationScreen extends StatefulWidget {
  const SlideInMenuAnimationScreen({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SlideInMenuAnimationScreen> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(
            child: Text(
              'Main Content',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          // Slide-in Menu
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _isMenuOpen ? 0 : -200, // Adjust this value according to your menu width
            child: Container(
              width: 200, // Width of the menu
              color: Colors.pink[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      // Handle menu item tap
                      _toggleMenu();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      // Handle menu item tap
                      _toggleMenu();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleMenu,
        tooltip: 'Toggle Menu',
        child: Icon(_isMenuOpen ? Icons.close : Icons.menu),
      ),
    );
  }
}
