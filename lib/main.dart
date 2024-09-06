// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cube/cube_to_die_screen.dart';

void main() {
  // runApp(
  //     DevicePreview(
  //       builder: (context) => const MyApp()
  //     )
  //   );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: CubeToDieScreen(),
    );

    // return MaterialApp(
    //     title: 'Progressive blur effect',
    //     useInheritedMediaQuery: true,
    //     locale: DevicePreview.locale(context),
    //     builder: DevicePreview.appBuilder,
    //     theme: ThemeData(
    //       useMaterial3: true,
    //     ),
    //     debugShowCheckedModeBanner: false,
    //     home: BlurrySearchScreen(),
    //   );

    // return ChangeNotifierProvider(
    //   create: (context) => PuzzleProvider(),
    //   child: MaterialApp(
    //     title: 'Jigsaw Puzzle',
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),
    //     debugShowCheckedModeBanner: false,
    //     home: PuzzlePage(),
    //   ),
    // );

    // return ChangeNotifierProvider(
    //   create: (context) => PhotoProvider(),
    //   child: MaterialApp(
    //     title: 'Photo Organizer',
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),
    //     debugShowCheckedModeBanner: false,
    //     home: PhotoOrganizerScreen(),
    //   ),
    // );

    // return ChangeNotifierProvider(
    //   create: (context) => CartModel(),
    //   child: MaterialApp(
    //     title: 'Shopping Cart',
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),
    //     debugShowCheckedModeBanner: false,
    //     home: ShoppingPage(),
    //   ),
    // );
  }
}
