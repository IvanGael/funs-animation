// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';


class ListWithAnimation extends StatefulWidget {
  const ListWithAnimation({super.key});

  @override
  _AnimatedListDemoState createState() => _AnimatedListDemoState();
}

class _AnimatedListDemoState extends State<ListWithAnimation> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<String> _listItems = ['Item 1', 'Item 2', 'Item 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _listItems.length,
        itemBuilder: (context, index, animation) {
          return _buildItem(_listItems[index], animation, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addItem();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildItem(String item, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          title: Text(item),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _removeItem(index);
            },
          ),
        ),
      ),
    );
  }

  void _addItem() {
    final int newIndex = _listItems.length;
    _listItems.add('Item ${newIndex + 1}');
    _listKey.currentState!.insertItem(newIndex);
  }

  void _removeItem(int index) {
    final removedItem = _listItems.removeAt(index);
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => _buildItem(removedItem, animation, index),
    );
  }
}
