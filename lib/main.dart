import 'package:flutter/material.dart';

import 'animated_progress_bar_with_gradient.dart';
import 'avatar_animation.dart';
import 'background_with_animation.dart';
import 'chat_with_bubble_animation.dart';
import 'color_cycle_animation.dart';
import 'countdown_timer_with_dynamic_changes.dart';
import 'dragging_with_animation.dart';
import 'fab_menu_reveal_options.dart';
import 'fancy_page_transition.dart';
import 'flip_book_animation.dart';
import 'geometric_pattern_animation.dart';
import 'image_parallax_animation.dart';
import 'list_with_animation.dart';
import 'numbers_particle_animation.dart';
import 'pull_to_refresh_animation.dart';
import 'rating_stars_animation.dart';
import 'slide_in_menu_animation.dart';
import 'splash_animation.dart';
import 'swipe_to_dismiss_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: FlipBookAnimationScreen(),
    );
  }
}
