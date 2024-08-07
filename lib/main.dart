import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'animated_photo_organizer.dart';
import 'animated_progress_bar_with_gradient.dart';
import 'animated_puzzle_game.dart';
import 'animated_shopping.dart';
import 'animated_stopwatch.dart';
import 'avatar_animation.dart';
import 'background_with_animation.dart';
import 'chat_with_bubble_animation.dart';
import 'circular_reveal_animation.dart';
import 'color_cycle_animation.dart';
import 'countdown_timer_with_dynamic_changes.dart';
import 'countries_discover_home.dart';
import 'cube_puzzle_animation.dart';
import 'custom_keyboard.dart';
import 'disintegrate_image_animation.dart';
import 'dragging_with_animation.dart';
import 'fab_menu_reveal_options.dart';
import 'fancy_page_transition.dart';
import 'flip_book_animation.dart';
import 'flip_clock_countdown.dart';
import 'furniture_arranger.dart';
import 'geometric_pattern_animation.dart';
import 'gradient_background_with_animation.dart';
import 'historical_timeline.dart';
import 'image_pan_slider_page.dart';
import 'image_parallax_animation.dart';
import 'image_puzzling.dart';
import 'interactive_menu.dart';
import 'beer_from_animation.dart';
import 'list_with_animation.dart';
import 'mind_mapping.dart';
import 'minesweeper_game/minesweeper_home_game.dart';
import 'numbers_particle_animation.dart';
import 'parallax_rain_screen.dart';
import 'photo_zoom.dart';
import 'preview_image_gallery.dart';
import 'pull_to_refresh_animation.dart';
import 'rating_stars_animation.dart';
import 'reoderable_event_list.dart';
import 'rss_feed_reader/rss_feed_page.dart';
import 'scrollable_card_list.dart';
import 'slide_in_menu_animation.dart';
import 'splash_animation.dart';
import 'swipe_to_dismiss_card.dart';
import 'text_puzzle_animation.dart';
import 'virtual_aquarium.dart';
import 'whiteboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData.dark(
    //     // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //   ),
    //   debugShowCheckedModeBanner: false,
    //   home: RSSFeedPage(),
    // );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: ScrollableCardList(),
    );

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


    // return ChangeNotifierProvider(
    //   create: (context) => FurnitureModel(),
    //   child: MaterialApp(
    //     title: 'Furniture Arranger',
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),
    //     debugShowCheckedModeBanner: false,
    //     home: FurnitureArrangerScreen(),
    //   ),
    // );
  }
}
