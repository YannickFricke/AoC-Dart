import 'package:advent_of_code/vector.dart';

abstract class BaseGrid<TileType> {
  List<List<TileType>> tiles;

  BaseGrid(this.tiles);

  int get height => tiles.length;

  int get width => tiles[0].length;

  bool isPositionInGrid(Vector2 positionToCheck) {
    if (positionToCheck.x < 0) {
      return false;
    }

    if (positionToCheck.x >= width) {
      return false;
    }

    if (positionToCheck.y < 0) {
      return false;
    }

    if (positionToCheck.y >= height) {
      return false;
    }

    return true;
  }
}
