import 'package:flutter/material.dart';



class MindMapScreen extends StatefulWidget {
  @override
  _MindMapScreenState createState() => _MindMapScreenState();
}

class _MindMapScreenState extends State<MindMapScreen> {
  List<MindMapNode> nodes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mind Mapping Tool'),
      ),
      body: Stack(
        children: [
          for (var node in nodes)
            MindMapNodeWidget(
              key: UniqueKey(),
              node: node,
              onNodeDrag: (offset) {
                setState(() {
                  node.position += offset;
                });
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            nodes.add(MindMapNode(position: Offset(50.0, 50.0), text: 'Node'));
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class MindMapNode {
  Offset position;
  String text;

  MindMapNode({required this.position, required this.text});
}

typedef OnNodeDrag = void Function(Offset offset);

class MindMapNodeWidget extends StatefulWidget {
  final MindMapNode node;
  final OnNodeDrag onNodeDrag;

  const MindMapNodeWidget({
    Key? key,
    required this.node,
    required this.onNodeDrag,
  }) : super(key: key);

  @override
  _MindMapNodeWidgetState createState() => _MindMapNodeWidgetState();
}

class _MindMapNodeWidgetState extends State<MindMapNodeWidget> {
  late Offset _position;
  late Offset _dragOffset;

  @override
  void initState() {
    super.initState();
    _position = widget.node.position;
    _dragOffset = Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx + _dragOffset.dx,
      top: _position.dy + _dragOffset.dy,
      child: GestureDetector(
        onPanStart: (details) {
          _dragOffset = _position - details.localPosition;
        },
        onPanUpdate: (details) {
          setState(() {
            _position = details.localPosition + _dragOffset;
          });
          widget.onNodeDrag(_dragOffset);
        },
        child: Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              widget.node.text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
