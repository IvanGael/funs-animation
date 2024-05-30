// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class FurnitureItem {
  final String id;
  final String name;
  final Widget icon;
  Offset position;

  FurnitureItem({
    required this.id,
    required this.name,
    required this.icon,
    this.position = Offset.zero,
  });
}

class FurnitureModel with ChangeNotifier {
  final List<FurnitureItem> _items = [
    FurnitureItem(
      id: '1',
      name: 'Chair',
      icon: const Icon(Icons.chair, size: 150),
      position: const Offset(40, 350)
    ),
    FurnitureItem(
      id: '2',
      name: 'Table',
      icon: const Icon(Icons.table_chart, size: 150),
      position: const Offset(200, 350)
    ),
  ];

  List<FurnitureItem> get items => _items;

  void updatePosition(String id, Offset newPosition) {
    final item = _items.firstWhere((item) => item.id == id);
    item.position = newPosition;
    notifyListeners();
  }
}



class FurnitureDragDrop extends StatelessWidget {
  const FurnitureDragDrop({super.key});

  @override
  Widget build(BuildContext context) {
    final furnitureItems = context.watch<FurnitureModel>().items;

    return Stack(
      alignment: Alignment.center,
      children: furnitureItems.map((item) {
        return Positioned(
          left: item.position.dx,
          top: item.position.dy,
          child: DraggableFurniture(item: item),
        );
      }).toList(),
    );
  }
}

class DraggableFurniture extends StatefulWidget {
  final FurnitureItem item;

  const DraggableFurniture({super.key, required this.item});

  @override
  _DraggableFurnitureState createState() => _DraggableFurnitureState();
}

class _DraggableFurnitureState extends State<DraggableFurniture>
    with SingleTickerProviderStateMixin {
  late Offset _dragOffset;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _dragOffset = widget.item.position;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  void _snapToGrid() {
    const gridSize = 50.0; 
    final snappedX = (widget.item.position.dx / gridSize).round() * gridSize;
    final snappedY = (widget.item.position.dy / gridSize).round() * gridSize;
    final snappedPosition = Offset(snappedX, snappedY);

    _animation = Tween<Offset>(
      begin: _dragOffset,
      end: snappedPosition,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward(from: 0).then((_) {
      Provider.of<FurnitureModel>(context, listen: false)
          .updatePosition(widget.item.id, snappedPosition);
      setState(() {
        _dragOffset = snappedPosition;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _animation.value.dx,
          top: _animation.value.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _dragOffset += details.delta;
                Provider.of<FurnitureModel>(context, listen: false).updatePosition(widget.item.id, _dragOffset);
              });
            },
            onPanEnd: (details) {
              _snapToGrid();
            },
            child: widget.item.icon,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}




class FurnitureArrangerScreen extends StatelessWidget {
  const FurnitureArrangerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          RoomBackground(),
          FurnitureDragDrop(),
        ],
      ),
    );
  }
}

class RoomBackground extends StatelessWidget {
  const RoomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
    );
  }
}