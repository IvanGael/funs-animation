import 'package:flutter/material.dart';


class Event {
  String name;
  DateTime date;
  String description;

  Event({required this.name, required this.date, required this.description});
}

class ReoderableEventList extends StatelessWidget {
  final List<Event> events = [
    Event(name: "Event 1", date: DateTime(1900), description: "Description 1"),
    Event(name: "Event 2", date: DateTime(1920), description: "Description 2"),
    Event(name: "Event 3", date: DateTime(1950), description: "Description 3"),
  ];

  ReoderableEventList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ReorderableListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: events
              .map((event) => ListTile(
                    key: ValueKey(event),
                    title: Text(event.name),
                    subtitle: Text(event.description),
                    leading: Text("${event.date.year}"),
                    trailing: const Icon(Icons.drag_handle),
                  ))
              .toList(),
          onReorder: (oldIndex, newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final Event movedEvent = events.removeAt(oldIndex);
            events.insert(newIndex, movedEvent);
          },
        ),
      );
  }
}
