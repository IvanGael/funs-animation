// ignore_for_file: library_private_types_in_public_api, avoid_unnecessary_containers


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Item {
  final String image;
  final String name;
  final double price;
  int quantity; 

  Item(this.image, this.name, this.price, {this.quantity = 0}); 
}



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

  @override
  void didUpdateWidget(covariant ShoppingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
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
                  "Your cart is empty!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              width: 2
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
        title: const Text('Groc. Store',
            style: TextStyle(
                color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 10,
        shadowColor: Colors.black,
        actions: [
          IconButton(
            onPressed: (){
              Provider.of<CartModel>(context, listen: false).reset();
            }, 
            icon: const Icon(Icons.remove_shopping_cart, color: Colors.deepPurpleAccent,)
          )
        ],
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
    Item("assets/lemon.png", "lemon", 10),
    Item("assets/lettuce.png", "lettuce", 12),
    Item("assets/soft-drink.png", "soft drink", 22),
    Item("assets/bibimbap.png", "bibimbap", 25),
    Item("assets/whopper.png", "whopper", 15),
    Item("assets/burger.png", "burger", 26),
    Item("assets/diet.png", "diet", 20),
     Item("assets/apple.png", "apple", 8),
    Item("assets/chicken.png", "chicken", 1),
    Item("assets/fries.png", "fries", 35),
    Item("assets/donut.png", "donut", 3),
    Item("assets/beans.png", "beans", 10),
    Item("assets/pizza.png", "pizza", 40),
    Item("assets/ramen.png", "ramen", 30),
    Item("assets/salad.png", "salad", 35),
    Item("assets/taco.png", "taco", 15)
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
          // const SizedBox(height: 18.0),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     IconButton(
          //       style: ButtonStyle(
          //         backgroundColor: WidgetStateProperty.all(Colors.greenAccent),
          //         shape: WidgetStateProperty.all(
          //           RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(8)
          //           )
          //         ),
          //       ),
          //       onPressed: (){
          //         Provider.of<CartModel>(context, listen: false).decreaseQte(item);
          //       }, 
          //       icon: const Icon(Icons.remove, color: Colors.black,)
          //     ),
          //     const SizedBox(width: 6,),
          //     // Text(
          //     //   item.quantity.toStringAsFixed(0),
          //     //   style: const TextStyle(
          //     //     color: Colors.deepPurple,
          //     //     fontSize: 20,
          //     //     fontWeight: FontWeight.bold
          //     //   ),
          //     // ),
          //     FutureBuilder(
          //       future: Provider.of<CartModel>(context).getItemQuantity(item),
          //       builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          //         if (snapshot.connectionState == ConnectionState.waiting) {
          //           return CircularProgressIndicator(); // Show loading indicator while waiting for the future to complete.
          //         } else {
          //           if (snapshot.hasError) {
          //             return Text('Error: ${snapshot.error}');
          //           } else {
          //             return Text(
          //               snapshot.data.toString(), // Display the quantity retrieved from the future.
          //               style: const TextStyle(
          //                 color: Colors.deepPurple,
          //                 fontSize: 20,
          //                 fontWeight: FontWeight.bold
          //               ),
          //             );
          //           }
          //         }
          //       },
          //     ),
          //     const SizedBox(width: 6,),
          //     IconButton(
          //       style: ButtonStyle(
          //         backgroundColor: WidgetStateProperty.all(Colors.greenAccent),
          //         shape: WidgetStateProperty.all(
          //           RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(8)
          //           )
          //         )
          //       ),
          //       onPressed: (){
          //         Provider.of<CartModel>(context, listen: false).increaseQte(item);
          //       }, 
          //       icon: const Icon(Icons.add, color: Colors.black,)
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}


class CartModel extends ChangeNotifier {
  final List<Item> _items = [];

  List<Item> get items => _items;

  Item findItem(Item item) {
    return _items.firstWhere((i) => i.name == item.name, orElse: () => item);
  }

  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void reset() {
    _items.clear();
    notifyListeners();
  }


  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.price);
  }
}





class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late AnimationController _scanningAnimationController;
  final Duration _scanningAnimationDuration = const Duration(seconds: 2);

  bool _isScanning = false;

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

    _scanningAnimationController = AnimationController(
      vsync: this,
      duration: _scanningAnimationDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scanningAnimationController.dispose();
    super.dispose();
  }

  void _runAnimation(DragTargetDetails<Item> details) async {
    setState(() {
      _isScanning = true;
    });

    await Future.delayed(const Duration(milliseconds: 400), () {
      _controller.forward().then((value) => _controller.reverse());
      _scanningAnimationController.forward().then((value) {
        _scanningAnimationController.reverse();
        Provider.of<CartModel>(context, listen: false).addItem(details.data);
        setState(() {
          _isScanning = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<Item>(
      onAcceptWithDetails: (details) {
        _runAnimation(details);
      },
      builder: (context, candidateData, rejectedData) {
        double totalPrice = Provider.of<CartModel>(context).totalPrice;

        return ScaleTransition(
          scale: _animation,
          child: Container(
            height: _isScanning ? 200 : 180,
            color: Colors.deepPurpleAccent,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (candidateData.isNotEmpty)
                    Image.asset(
                      candidateData.first!.image,
                      width: 50,
                      height: 50,
                    ),
                    if (!_isScanning)
                  Image.asset(
                    "assets/barcode-lt.png",
                    width: 100,
                    height: 60,
                    fit: BoxFit.fitWidth,
                  ),
                  if (_isScanning)
                    CustomPaint(
                      painter: ScannerPainter(animation: _scanningAnimationController),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                      ),
                    ),
                  const Text(
                    'Drag items here to add to cart',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total: \$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23.0,
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


class ScannerPainter extends CustomPainter {
  final Animation<double> animation;

  ScannerPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    Paint bgPaint = Paint()..color = Colors.deepPurpleAccent;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    double value = animation.value;

    Paint gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.cyanAccent, Colors.greenAccent.shade200,],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 5;

    // Draw scanning line vertically
    Paint linePaint = Paint()
      ..color = Colors.greenAccent
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
      ..strokeWidth = 5;

    double lineWidth = size.width ;
    double lineY = size.height * value;

    if(animation.value != 0){
      canvas.drawLine(Offset(0, lineY + 3), Offset(lineWidth, lineY + 3), linePaint);
      canvas.drawLine(Offset(0, lineY), Offset(lineWidth, lineY), gradientPaint);
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


