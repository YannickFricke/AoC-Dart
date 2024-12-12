import 'package:advent_of_code/vector.dart';

enum Direction {
  up((x: 0, y: -1)),
  upRight((x: 1, y: -1)),
  right((x: 1, y: 0)),
  downRight((x: 1, y: 1)),
  down((x: 0, y: 1)),
  downLeft((x: -1, y: 1)),
  left((x: -1, y: 0)),
  upLeft((x: -1, y: -1));

  final Vector2 offset;

  const Direction(this.offset);

  Direction turnCardinalDirectionClockwise() {
    switch (this) {
      case up:
        return Direction.right;
      case right:
        return Direction.down;
      case down:
        return Direction.left;
      case left:
        return Direction.up;
      default:
        throw Exception("Cannot turn non-cardinal direction: $this");
    }
  }

  /// Returns a list of cardinal directions.
  ///
  /// Cardinal directions are:
  /// - up
  /// - right
  /// - down
  /// - left
  static List<Direction> get cardinal => [up, right, down, left];

  /// Returns a list of diagonal directions.
  ///
  /// Diagonal directions are:
  /// - upRight
  /// - downRight
  /// - downLeft
  /// - upLeft
  static List<Direction> get diagonal => [upRight, downRight, downLeft, upLeft];
}
