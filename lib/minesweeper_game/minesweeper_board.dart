import 'package:flutter/material.dart';
import 'cell_model.dart';

class MinesweeperBoard extends StatelessWidget {
  final List<List<CellModel>> board;
  final Function(int, int) onReveal;
  final Function(int, int) onFlag;

  const MinesweeperBoard(this.board, this.onReveal, this.onFlag, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: board.length),
      itemBuilder: (context, index) {
        int row = index ~/ board.length;
        int col = index % board.length;
        return GestureDetector(
          onTap: () => onReveal(row, col),
          onLongPress: () => onFlag(row, col),
          child: _buildCell(board[row][col]),
        );
      },
      itemCount: board.length * board.length,
    );
  }

  Widget _buildCell(CellModel cell) {
    switch (cell.state) {
      case CellState.hidden:
        return Container(
          margin: const EdgeInsets.all(2.0),
          color: Colors.grey,
        );
      case CellState.revealed:
        return Container(
          margin: const EdgeInsets.all(2.0),
          color: Colors.white,
          child: Center(
            child: Text(
              cell.adjacentMines > 0 ? cell.adjacentMines.toString() : '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      case CellState.flagged:
        return Container(
          margin: const EdgeInsets.all(2.0),
          color: Colors.yellow,
          child: const Center(
            child: Icon(Icons.flag),
          ),
        );
      default:
        return Container();
    }
  }
}
