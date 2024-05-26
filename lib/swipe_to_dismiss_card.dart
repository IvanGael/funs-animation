// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class SwipeToDismissCard extends StatefulWidget {
  const SwipeToDismissCard({super.key});

  @override
  _SwipeToDismissDemoState createState() => _SwipeToDismissDemoState();
}

class _SwipeToDismissDemoState extends State<SwipeToDismissCard> {
  final List<String> items = List.generate(10, (index) => "Item ${index + 1}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Dismissible(
            key: Key(item),
            background: Container(
              color: Colors.red,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                items.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$item dismissed"),
                ),
              );
            },
            child: ListTile(
              title: Text(item),
            ),
          );
        },
      ),
    );
  }
}
