// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';


class PhotoZoomPage extends StatefulWidget {
  const PhotoZoomPage({super.key});

  @override
  _PhotoZoomPageState createState() => _PhotoZoomPageState();
}

class _PhotoZoomPageState extends State<PhotoZoomPage> {
  bool _zoomedIn = false;

  void _toggleZoom() {
    setState(() {
      _zoomedIn = !_zoomedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: _toggleZoom,
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            width: _zoomedIn ? MediaQuery.of(context).size.width : 400,
            height: _zoomedIn ? MediaQuery.of(context).size.height : 300,
            child: _zoomedIn ?
            Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
              'assets/nature4.jpg',
              fit: BoxFit.cover,
            ),
            const Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.directions, color: Colors.white, size: 30,),
                    Text(
                      "Skogafoss",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "Iceland",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13
                      ),
                    )
                  ],
                ),
              )
            )
              ],
            ) :
            Image.asset(
              'assets/nature4.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
