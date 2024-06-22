// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:flutter/material.dart';
import 'cell_model.dart';
import 'minesweeper_board.dart';

class MinesweeperHomeGame extends StatefulWidget {
  const MinesweeperHomeGame({super.key});

  @override
  _MinesweeperHomeGameState createState() => _MinesweeperHomeGameState();
}

class _MinesweeperHomeGameState extends State<MinesweeperHomeGame> {
  static const int gridSize = 10;
  static const int mineCount = 10;

  late List<List<CellModel>> board;

  @override
  void initState() {
    super.initState();
    board = _initializeBoard(gridSize, mineCount);
  }

  List<List<CellModel>> _initializeBoard(int size, int mines) {
    List<List<CellModel>> board = List.generate(size, (i) => List.generate(size, (j) => CellModel()));
    _generateMines(board, mines);
    _calculateAdjacentMines(board);
    return board;
  }

  void _generateMines(List<List<CellModel>> board, int mineCount) {
    int placedMines = 0;
    final random = Random();
    while (placedMines < mineCount) {
      int row = random.nextInt(board.length);
      int col = random.nextInt(board.length);
      if (board[row][col].state != CellState.mine) {
        board[row][col].state = CellState.mine;
        placedMines++;
      }
    }
  }

  void _calculateAdjacentMines(List<List<CellModel>> board) {
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board.length; col++) {
        if (board[row][col].state == CellState.mine) continue;
        int mineCount = 0;
        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            int newRow = row + i;
            int newCol = col + j;
            if (newRow >= 0 && newRow < board.length && newCol >= 0 && newCol < board.length) {
              if (board[newRow][newCol].state == CellState.mine) {
                mineCount++;
              }
            }
          }
        }
        board[row][col].adjacentMines = mineCount;
      }
    }
  }

  void _revealCell(int row, int col) {
    setState(() {
      if (board[row][col].state == CellState.hidden) {
        if (board[row][col].state == CellState.mine) {
          // Game over logic
          _showGameOverDialog();
        } else {
          _revealAdjacentCells(row, col);
        }
      }
    });
  }

  void _revealAdjacentCells(int row, int col) {
    if (row < 0 || row >= board.length || col < 0 || col >= board.length) return;
    if (board[row][col].state != CellState.hidden) return;

    setState(() {
      board[row][col].state = CellState.revealed;
    });

    if (board[row][col].adjacentMines == 0) {
      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          _revealAdjacentCells(row + i, col + j);
        }
      }
    }
  }

  void _flagCell(int row, int col) {
    setState(() {
      if (board[row][col].state == CellState.hidden) {
        board[row][col].state = CellState.flagged;
      } else if (board[row][col].state == CellState.flagged) {
        board[row][col].state = CellState.hidden;
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text('You hit a mine!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  board = _initializeBoard(gridSize, mineCount);
                });
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minesweeper'),
      ),
      body: MinesweeperBoard(board, _revealCell, _flagCell)
    );
  }
}
