// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';

class WhiteboardScreen extends StatefulWidget {
  const WhiteboardScreen({super.key});

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
        title: const Text('Noteboard'),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Whiteboard(notes: notes),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            notes.add(Note(
              id: _noteId++,
              offset: const Offset(100.0, 100.0),
              size: const Size(150.0, 100.0),
              color: Colors.yellow,
              text: '',
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

  const Whiteboard({super.key, required this.notes});

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

class Note extends StatefulWidget {
  late final int id;
  late Offset offset;
  final Size size;
  final Color color;
  String text;
  bool dragging;

  Note({
    super.key,
    required this.id,
    required this.offset,
    required this.size,
    required this.color,
    required this.text,
    this.dragging = false,
  });

  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      left: widget.offset.dx,
      top: widget.offset.dy,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateX(0.01) // folded effect
          ..rotateY(0.01), // folded effect
        alignment: FractionalOffset.center,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: widget.size.width,
          height: widget.size.height,
          color: widget.color,
          child: Center(
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  widget.text = value;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
