import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PuzzlePage extends StatelessWidget {
  const PuzzlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jigsaw Puzzle'),
      ),
      body: Stack(
        children: [
          ...context.watch<PuzzleProvider>().pieces.map((piece) => DraggablePiece(piece: piece)),
        ],
      ),
    );
  }
}

class DraggablePiece extends StatelessWidget {
  final PuzzlePiece piece;

  const DraggablePiece({super.key, required this.piece});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: piece.currentPosition.dx,
      top: piece.currentPosition.dy,
      child: Draggable<PuzzlePiece>(
        data: piece,
        feedback: _buildPiece(context, isDragging: true),
        onDraggableCanceled: (velocity, offset) {
          context.read<PuzzleProvider>().updatePiecePosition(piece, offset);
        },
        child: _buildPiece(context),
      ),
    );
  }

  Widget _buildPiece(BuildContext context, {bool isDragging = false}) {
    return Container(
      width: piece.size.width,
      height: piece.size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(piece.imagePath),
          fit: BoxFit.cover,
        ),
        border: isDragging ? Border.all(color: Colors.red, width: 2) : null,
      ),
    );
  }
}

class PuzzlePiece {
  final String imagePath;
  final Offset correctPosition;
  Offset currentPosition;
  final Size size;

  PuzzlePiece({
    required this.imagePath,
    required this.correctPosition,
    required this.currentPosition,
    required this.size,
  });
}

class PuzzleProvider with ChangeNotifier {
  final List<PuzzlePiece> _pieces = [
    PuzzlePiece(
      imagePath: 'assets/manga1.jpg',
      correctPosition: const Offset(100, 100),
      currentPosition: const Offset(0, 0),
      size: const Size(100, 100),
    ),
    PuzzlePiece(
      imagePath: 'assets/manga2.jpg',
      correctPosition: const Offset(200, 100),
      currentPosition: const Offset(0, 200),
      size: const Size(100, 100),
    ),
  ];

  List<PuzzlePiece> get pieces => _pieces;

  void updatePiecePosition(PuzzlePiece piece, Offset newPosition) {
    piece.currentPosition = newPosition;
    if ((piece.correctPosition - piece.currentPosition).distance < 20) {
      piece.currentPosition = piece.correctPosition;
    }
    notifyListeners();
  }
}
