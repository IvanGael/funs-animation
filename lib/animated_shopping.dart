// ignore_for_file: library_private_types_in_public_api, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  List<Item> _itemsInCart = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _itemsInCart = Provider.of<CartModel>(context).items;
  }

  void showItemsInCart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: _itemsInCart.isEmpty
              ? const Center(
                  child: Text(
                  "Nothing added yet!",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ))
              : ListView.separated(
                  itemCount: _itemsInCart.length,
                  separatorBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                    );
                  },
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(_itemsInCart[index].name),
                      background: Container(
                        // color: Colors.white,
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      onDismissed: (direction) {
                        Provider.of<CartModel>(context, listen: false)
                            .removeItem(index);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration:  BoxDecoration(
                            border: Border.all(
                              color: Colors.deepPurpleAccent,
                              width: 1
                            ),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              _itemsInCart[index].image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _itemsInCart[index].name,
                              style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "\$${_itemsInCart[index].price.toString()}",
                              style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop',
            style: TextStyle(
                color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey.shade200,
        elevation: 10,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ItemsList(),
          ),
          const Cart()
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          showItemsInCart(context);
        },
        child: const Icon(Icons.list),
      ),
    );
  }
}

class ItemsList extends StatelessWidget {
  // final List<Item> items = List.generate(
  //   10,
  //   (index) => Item('Item $index', index.toDouble()),
  // );

  final List<Item> items = [
    Item("assets/apple.png", "apple", 8),
    Item("assets/chicken.png", "chicken", 45),
    Item("assets/fries.png", "fries", 35),
    Item("assets/lemon.png", "lemon", 10),
    Item("assets/onion-rings.png", "onion rings", 12),
    Item("assets/soft-drink.png", "soft drink", 50),
    Item("assets/veggie.png", "veggie", 25),
    Item("assets/whopper.png", "whopper", 15)
  ];

  ItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return DraggableItem(item: items[index]);
      },
    );
  }
}

class DraggableItem extends StatelessWidget {
  final Item item;

  const DraggableItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Draggable<Item>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        child: ItemCard(item: item, isBeingDragged: true),
      ),
      childWhenDragging: ItemCard(item: item, isBeingDragged: true),
      child: ItemCard(item: item),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Item item;
  final bool isBeingDragged;

  const ItemCard({super.key, required this.item, this.isBeingDragged = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isBeingDragged ? 0 : 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            item.image,
            height: 100,
          ),
          const SizedBox(height: 8.0),
          Text(
            item.name,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8.0),
          Text(
            '\$${item.price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runAnimation() {
    _controller.forward().then((value) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<Item>(
      onAcceptWithDetails: (details) {
        Provider.of<CartModel>(context, listen: false).addItem(details.data);
        _runAnimation();
      },
      builder: (context, candidateData, rejectedData) {
        double totalPrice = Provider.of<CartModel>(context).totalPrice;

        return ScaleTransition(
          scale: _animation,
          child: Container(
            height: 100.0,
            color: Colors.deepPurpleAccent,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Drag items here to add to cart',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total: \$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class Item {
  final String image;
  final String name;
  final double price;

  Item(this.image, this.name, this.price);
}

class CartModel extends ChangeNotifier {
  final List<Item> _items = [];

  List<Item> get items => _items;

  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.price);
  }
}
