enum CellState { hidden, revealed, flagged, mine }

class CellModel {
  CellState state;
  int adjacentMines;

  CellModel({this.state = CellState.hidden, this.adjacentMines = 0});
}
