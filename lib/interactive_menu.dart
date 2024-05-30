// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dish {
  final String name;
  final String image;
  final double price;

  Dish({required this.name, required this.image, required this.price});
}

class InteractiveMenu extends StatefulWidget {
  const InteractiveMenu({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<InteractiveMenu> {
  List<Dish> selectedDishes = [];
  double totalPrice = 0.0;

  final List<Dish> dishes = [
    Dish(name: 'Spaghetti', image: 'assets/spaghetti.png', price: 10.0),
    Dish(name: 'Pizza', image: 'assets/pizzaa.png', price: 8.0),
    Dish(name: 'Burger', image: 'assets/burgerr.png', price: 7.0),
    Dish(name: 'Salad', image: 'assets/saladd.png', price: 5.0),
    Dish(name: 'Sushi', image: 'assets/sushi.png', price: 12.0),
  ];

  void addDish(Dish dish) {
    setState(() {
      selectedDishes.add(dish);
      totalPrice += dish.price;
    });
  }

  void removeDish(Dish dish) {
    setState(() {
      if (selectedDishes.isNotEmpty) {
        selectedDishes.remove(dish);
        totalPrice -= dish.price;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: DishesList(
              dishes: dishes,
              onDishDragged: addDish,
              onDishTapped: (dish) {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: DishDetails(dish: dish),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SelectionPlate(
            dishes: selectedDishes,
            onDishAdded: addDish,
            onDishRemoved: removeDish,
          ),
        ],
      ),
    );
  }
}

class DishesList extends StatelessWidget {
  final List<Dish> dishes;
  final Function(Dish) onDishDragged;
  final Function(Dish) onDishTapped;

  const DishesList({
    super.key,
    required this.dishes,
    required this.onDishDragged,
    required this.onDishTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dishes.length,
      itemBuilder: (context, index) {
        final dish = dishes[index];
        return GestureDetector(
          onTap: () => onDishTapped(dish),
          child: Draggable<Dish>(
            data: dish,
            feedback: Image.asset(
              dish.image,
              width: 60,
              height: 60,
            ),
            childWhenDragging: Opacity(
              opacity: 0.5,
              child: DishItem(dish: dish),
            ),
            child: DishItem(dish: dish),
          ),
        );
      },
    );
  }
}

class DishItem extends StatelessWidget {
  final Dish dish;

  const DishItem({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(dish.image, width: 50, height: 50),
            const SizedBox(width: 16),
            Text(
              dish.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectionPlate extends StatefulWidget {
  final List<Dish> dishes;
  final Function(Dish) onDishAdded;
  final Function(Dish) onDishRemoved;

  const SelectionPlate({
    super.key,
    required this.dishes,
    required this.onDishAdded,
    required this.onDishRemoved,
  });

  @override
  _SelectionPlateState createState() => _SelectionPlateState();
}

class _SelectionPlateState extends State<SelectionPlate>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant SelectionPlate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dishes.length > oldWidget.dishes.length) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.pink[700],
      ),
      child: DragTarget<Dish>(
        onAcceptWithDetails: (dish) {
          setState(() {
            widget.onDishAdded(dish.data);
            _controller.forward(from: 0.0);
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Stack(
                children: [
                  Transform.rotate(
                    angle: 19,
                    child: Image.asset(
                      'assets/plate.png',
                      width: 250,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  for (int i = 0; i < widget.dishes.length; i++)
                    Positioned(
                      left: 90 + 70 * cos(2 * pi * i / widget.dishes.length),
                      top: 60 + 30 * sin(2 * pi * i / widget.dishes.length),
                      child: ScaleTransition(
                        scale: _animation,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              widget.onDishRemoved(widget.dishes[i]);
                            },
                            child: Image.asset(
                              widget.dishes[i].image,
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}

class DishDetails extends StatelessWidget {
  final Dish dish;

  const DishDetails({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dish.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Price: \$${dish.price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            'Description: Delicious ${dish.name} made with fresh ingredients.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
