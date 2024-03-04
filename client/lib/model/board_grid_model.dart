import 'package:client/model/board_space_model.dart';

class BoardGridModel {
  BoardGridModel(this._depth) {

    _spaces = List<List<BoardSpaceModel>>.empty(growable: true);
    for (int i = 0; i < (_depth * 2) + 1; i++) {
      var row = List<BoardSpaceModel>.empty(growable: true);
      for (int j = 0; j < (_depth * 2) + 1; j++) {
        row.add(BoardSpaceModel(i, j, board[i][j])); //TODO: DEAL WITH THIS
      }
      _spaces.add(row);
    }
  }
  late List<List<BoardSpaceModel>> _spaces;
  final int _depth;

  set spaces(spaces) => _spaces = spaces;
  List<List<BoardSpaceModel>> get spaces => _spaces;
  setSpace(int q, int r, BoardSpaceModel space) => _spaces[q][r] = space;

}
