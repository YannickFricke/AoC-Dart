import 'package:advent_of_code/base_grid.dart';
import 'package:advent_of_code/direction.dart';
import 'package:advent_of_code/utils.dart';
import 'package:advent_of_code/vector.dart';

Direction parseDirection(String input) {
  switch (input) {
    case "^":
      return Direction.up;

    case ">":
      return Direction.right;

    case "v":
      return Direction.down;

    case "<":
      return Direction.left;

    default:
      throw Exception("Unknown guard direction character: $input");
  }
}

String stringifyDirection(Direction direction) {
  switch (direction) {
    case Direction.up:
      return "^";
    case Direction.right:
      return ">";
    case Direction.down:
      return "v";
    case Direction.left:
      return "<";
    default:
      throw Exception("Cannot stringify unknown direction: $direction");
  }
}

typedef WalkedPosition = (Vector2, Direction);

class Grid extends BaseGrid<bool> {
  Vector2 guardPosition;

  Direction guardDirection;

  Grid(super.tiles, this.guardPosition, this.guardDirection);

  Set<Vector2> walkGuard() {
    final walkedPositions = <Vector2>{guardPosition};

    while (true) {
      final nextPosition = addVector2(guardDirection.offset, guardPosition);
      final isWalkable = tiles
          .elementAtOrNull(nextPosition.y)
          ?.elementAtOrNull(nextPosition.x);

      if (isWalkable == null) {
        break;
      }

      if (isWalkable == false) {
        guardDirection = guardDirection.turnCardinalDirectionClockwise();
        continue;
      }

      walkedPositions.add(nextPosition);
      guardPosition = nextPosition;
    }

    return walkedPositions;
  }

  bool canMoveOutOfGrid(
    Vector2 initialGuardPosition,
    Direction initialGuardDirection,
    Vector2 obstacleAtPosition,
  ) {
    guardPosition = initialGuardPosition;
    guardDirection = initialGuardDirection;

    final walkedPositions = <WalkedPosition>{};
    tiles[obstacleAtPosition.y][obstacleAtPosition.x] = false;

    while (true) {
      final nextPosition = addVector2(guardDirection.offset, guardPosition);

      if (isPositionInGrid(nextPosition) == false) {
        break;
      }

      final isWalkable = tiles
          .elementAtOrNull(nextPosition.y)
          ?.elementAtOrNull(nextPosition.x);

      if (isWalkable == null) {
        break;
      }

      if (walkedPositions.contains((guardPosition, guardDirection))) {
        tiles[obstacleAtPosition.y][obstacleAtPosition.x] = true;
        return false;
      }

      if (isWalkable == false) {
        guardDirection = guardDirection.turnCardinalDirectionClockwise();
        continue;
      }

      walkedPositions.add((guardPosition, guardDirection));
      guardPosition = nextPosition;
    }

    tiles[obstacleAtPosition.y][obstacleAtPosition.x] = true;
    return true;
  }

  @override
  String toString() {
    return 'Grid{tiles: $tiles, guardPosition: $guardPosition, guardDirection: $guardDirection}';
  }

  static Grid parseInput(String input) {
    final lines = input.split("\n");
    final rows = lines.map((line) => line.split("").toList()).toList();

    final tiles = <List<bool>>[];
    Vector2? guardPosition;
    Direction? guardDirection;

    for (var y = 0; y < rows.length; y++) {
      final currentRow = rows[y];
      final resultRow = <bool>[];

      for (var x = 0; x < currentRow.length; x++) {
        switch (currentRow[x]) {
          case ".":
            resultRow.add(true);
            break;

          case "#":
            resultRow.add(false);
            break;

          case var currentCharacter:
            guardPosition = (x: x, y: y);
            guardDirection = parseDirection(currentCharacter);
            resultRow.add(true);
            break;
        }
      }

      tiles.add(resultRow);
    }

    if (guardPosition == null || guardDirection == null) {
      throw Exception("Could not find guard position or direction");
    }

    return Grid(tiles, guardPosition, guardDirection);
  }
}

void part1() {
  final fileContents = readInputFile(2024, 6, "input");
  final grid = Grid.parseInput(fileContents);
  final walkedPath = grid.walkGuard();

  print(walkedPath.length);
}

void part2() {
  final fileContents = readInputFile(2024, 6, "input");

  final grid = Grid.parseInput(fileContents);
  final initialGuardDirection = grid.guardDirection;
  final initialGuardPosition = grid.guardPosition;

  final walkedPath = grid.walkGuard();
  final positionsToPutObstacleOn = walkedPath
      .expand((position) => [
            addVector2(Direction.up.offset, position),
            addVector2(Direction.right.offset, position),
            addVector2(Direction.down.offset, position),
            addVector2(Direction.left.offset, position),
            position,
          ])
      .toSet()
      .where((position) =>
          grid.tiles.elementAtOrNull(position.y)?.elementAtOrNull(position.x) ==
          true)
      .toList();

  positionsToPutObstacleOn.sort((a, b) => a.y.compareTo(b.y));

  final positionsWhereGuardCannotMoveOut =
      positionsToPutObstacleOn.where((position) {
    print("Checking obstacle position: $position");

    return grid.canMoveOutOfGrid(
          initialGuardPosition,
          initialGuardDirection,
          position,
        ) ==
        false;
  });
  final uniquePositions = positionsWhereGuardCannotMoveOut.toSet();

  print("Result: ${uniquePositions.length}");
}
