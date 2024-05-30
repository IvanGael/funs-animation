

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class HistoricalTimeline extends StatefulWidget {
  const HistoricalTimeline({super.key});

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}


class _TimelineScreenState extends State<HistoricalTimeline> {
  List<String> events = [
    "1900 - Event 1",
    "1920 - Event 2",
    "1940 - Event 3",
    "1960 - Event 4",
    "1980 - Event 5",
    "2000 - Event 6",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final String item = events.removeAt(oldIndex);
            events.insert(newIndex, item);
          });
        },
        children: List.generate(events.length, (index) {
          return AnimatedContainer(
            key: ValueKey(events[index]),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: Text(
                events[index],
                style: const TextStyle(color: Colors.white),
              ),
              tileColor: Colors.transparent,
            ),
          );
        }),
      ),
    );
  }
}