// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'custom_scroll_indicator.dart';

class ScrollableCardList extends StatefulWidget {
  const ScrollableCardList({super.key});

  @override
  _ScrollableCardListState createState() => _ScrollableCardListState();
}

class _ScrollableCardListState extends State<ScrollableCardList> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollPercentage = ValueNotifier<double>(0.0);
  bool _isScrolling = false;
  final int _itemsLength = 11;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      if (_scrollController.position.maxScrollExtent > 0) {
        _scrollPercentage.value = _scrollController.offset / _scrollController.position.maxScrollExtent;
      }
      setState(() {
        _isScrolling = _scrollController.position.isScrollingNotifier.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (){

            }, 
            icon: const Icon(Icons.menu, color: Colors.white,)
          )
        ],
        backgroundColor: Colors.pink.shade700,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            itemCount: _itemsLength,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _scrollController,
                builder: (context, child) {
                  if (!_isScrolling || !_scrollController.hasClients) {
                    return child!;
                  }

                  double itemPositionOffset = index * 136.0;
                  double difference = _scrollController.offset - itemPositionOffset;
                  double percent = 1 - (difference / (136 / 2)).abs();
                  double scale = 0.8 + (percent * 0.2);
                  double opacity = 0.25 + (percent * 0.75);

                  scale = scale.clamp(0.8, 1.0);
                  opacity = opacity.clamp(0.0, 1.0);

                  if (difference.abs() < 136) {
                    return Opacity(
                      opacity: opacity,
                      child: Transform.scale(
                        scale: scale,
                        child: child,
                      ),
                    );
                  } else {
                    return child!;
                  }
                },
                child: Card(
                  margin: const EdgeInsets.all(8),
                  color: Colors.indigoAccent,
                  elevation: 14,
                  shadowColor: Colors.indigo,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14)
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: CustomScrollIndicator(
                scrollPercentage: _scrollPercentage,
                itemCount: _itemsLength,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _scrollPercentage.dispose();
    super.dispose();
  }
}
