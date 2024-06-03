import 'package:flutter/material.dart';

class WhiteboardScreen extends StatefulWidget {
  const WhiteboardScreen({Key? key}) : super(key: key);

  @override
  _WhiteboardScreenState createState() => _WhiteboardScreenState();
}

class _WhiteboardScreenState extends State<WhiteboardScreen> {
  List<Note> notes = [];
  int _noteId = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Whiteboard'),
      ),
      body: Stack(
        children: [
          Whiteboard(notes: notes),
        ],
      ),
      floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {
                  notes.add(Note(
                    id: _noteId++, // Assign a unique ID to each note
                    offset: const Offset(100.0, 100.0),
                    size: const Size(150.0, 100.0),
                    color: Colors.yellow,
                    child: Text('Note ${_noteId + 1}'),
                  ));
                });
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}

class Whiteboard extends StatefulWidget {
  final List<Note> notes;

  const Whiteboard({Key? key, required this.notes}) : super(key: key);

  @override
  _WhiteboardState createState() => _WhiteboardState();
}

class _WhiteboardState extends State<Whiteboard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (var note in widget.notes)
          Positioned(
            left: note.offset.dx,
            top: note.offset.dy,
            child: Draggable(
              data: note,
              feedback: Material(
                child: note,
              ),
              childWhenDragging: Container(),
              onDragCompleted: () {
                setState(() {
                  note.dragging = false;
                });
              },
              onDraggableCanceled: (_, __) {
                setState(() {
                  note.dragging = false;
                });
              },
              onDragEnd: (details) {
                setState(() {
                  // Calculate the new position based on the delta values
                  note.offset = Offset(
                    details.offset.dx,
                    details.offset.dy,
                  );
                });
              },
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    // widget.notes.remove(note);
                    widget.notes.add(note);
                  });
                },
                onDoubleTap: () {
                  setState(() {
                    widget.notes.remove(note);
                  });
                },
                child: note,
              ),
            ),
          ),
      ],
    );
  }
}

class Note extends StatelessWidget {
  late final int id; 
  late Offset offset;
  final Size size;
  final Color color;
  final Widget child;
  bool dragging;

  Note({
    Key? key,
    required this.id,
    required this.offset,
    required this.size,
    required this.color,
    required this.child,
    this.dragging = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      left: offset.dx,
      top: offset.dy,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: size.width,
        height: size.height,
        color: color,
        child: Center(child: child),
      ),
    );
  }
}
