import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




class PhotoOrganizerScreen extends StatelessWidget {
  const PhotoOrganizerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final photoProvider = Provider.of<PhotoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Organizer'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
        ),
        itemCount: photoProvider.photos.length,
        itemBuilder: (context, index) {
          return DraggablePhoto(
            index: index,
          );
        },
      ),
    );
  }
}

class DraggablePhoto extends StatelessWidget {
  final int index;

  const DraggablePhoto({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final photoProvider = Provider.of<PhotoProvider>(context);
    final photo = photoProvider.photos[index];

    return LongPressDraggable<int>(
      data: index,
      feedback: Material(
        child: Image.asset(
          photo,
          // fit: BoxFit.cover,
          width: 150,
          height: 80,
        ),
      ),
      childWhenDragging: Container(),
      child: DragTarget<int>(
        builder: (context, candidateData, rejectedData) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Image.asset(
              photo,
              key: ValueKey(photo),
              fit: BoxFit.cover,
            ),
          );
        },
        onAcceptWithDetails: (fromIndex) {
          photoProvider.swapPhotos(fromIndex.data, index);
        },
      ),
    );
  }
}

class PhotoProvider with ChangeNotifier {
  final List<String> _photos = [
    'assets/nature.jpg',
    'assets/nature2.jpg',
    'assets/nature3.jpg',
    'assets/nature4.jpg',
    'assets/nature5.jpg',
    'assets/nature6.jpg',
    'assets/nature7.jpg',
    'assets/nature8.jpg',
  ];

  List<String> get photos => _photos;

  void swapPhotos(int fromIndex, int toIndex) {
    final photo = _photos.removeAt(fromIndex);
    _photos.insert(toIndex, photo);
    notifyListeners();
  }
}
