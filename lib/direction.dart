import 'package:advent_of_code/vector.dart';

enum Direction {
  up((x: 0, y: -1)),
  right((x: 1, y: 0)),
  down((x: 0, y: 1)),
  left((x: -1, y: 0));

  final Vector2 offset;

  const Direction(this.offset);

  Direction turnClockwise() {
    switch (this) {
      case up:
        return Direction.right;
      case right:
        return Direction.down;
      case down:
        return Direction.left;
      case left:
        return Direction.up;
    }
  }
}
