import 'package:advent_of_code/ansi_color.dart';
import 'package:advent_of_code/utils.dart';

enum Direction {
  up((x: 0, y: -1)),
  right((x: 1, y: 0)),
  down((x: 0, y: 1)),
  left((x: -1, y: 0));

  final Position offset;

  const Direction(this.offset);
}

typedef Position = ({int x, int y});

class Grid {
  final int width;
  final int height;
  final List<List<int>> tiles;

  Grid(this.width, this.height, this.tiles);

  @override
  String toString() {
    return 'Grid{width: $width, height: $height, tiles: $tiles}';
  }

  List<Position> getStartPositions() {
    final result = <Position>[];

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final currentHeight = tiles[y][x];

        if (currentHeight != 0) {
          continue;
        }

        result.add((x: x, y: y));
      }
    }

    return result;
  }

  bool isPositionInGrid(Position positionToCheck) {
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

  List<Position> calculateNeighbors(Position currentPosition) {
    final result = <Position>[];

    for (var direction in Direction.values) {
      final positionWithOffset = (
        x: currentPosition.x + direction.offset.x,
        y: currentPosition.y + direction.offset.y,
      );

      if (isPositionInGrid(positionWithOffset) == false) {
        continue;
      }

      result.add(positionWithOffset);
    }

    return result;
  }

  List<Set<Position>> calculatePaths() {
    final result = <Set<Position>>[];
    final startPositions = getStartPositions();

    for (var startPosition in startPositions) {
      result.addAll(calculatePathFromPosition(startPosition));
    }

    return result;
  }

  List<Set<Position>> calculatePathFromPosition(Position startPosition) {
    final result = <Set<Position>>[];
    final pathsToFollow = <Set<Position>>[
      {startPosition}
    ];

    while (pathsToFollow.isNotEmpty) {
      final currentPath = pathsToFollow.removeAt(0);

      final lastPosition = currentPath.last;
      final currentHeight = getHeightForPosition(lastPosition);

      final neighbors = calculateNeighbors(lastPosition);

      for (var neighbor in neighbors) {
        if (currentPath.contains(neighbor)) {
          continue;
        }

        final neighborHeight = getHeightForPosition(neighbor);

        if (neighborHeight != currentHeight + 1) {
          continue;
        }

        if (neighborHeight == 9) {
          result.add({...currentPath, neighbor});
          continue;
        }

        pathsToFollow.add({...currentPath, neighbor});
      }
    }

    return result;
  }

  int getHeightForPosition(Position position) => tiles[position.y][position.x];

  void printPath(Set<Position> path) {
    for (var y = 0; y < height; y++) {
      final row = <String>[];

      for (var x = 0; x < width; x++) {
        final Position currentPosition = (x: x, y: y);
        final currentHeight = getHeightForPosition(currentPosition);

        if (path.contains(currentPosition)) {
          row.add("${AnsiColor.red}$currentHeight${AnsiColor.reset}");
        } else {
          row.add(currentHeight.toString());
        }
      }

      print(row.join());
    }
  }

  static Grid parse(String input) {
    var width = 0;
    var height = 0;
    final tiles = <List<int>>[];

    final lines = input.split("\n");
    height = lines.length;

    for (var line in lines) {
      final row = <int>[];

      for (var character in line.split("")) {
        row.add(int.parse(character));
      }

      width = row.length;

      tiles.add(row);
    }

    return Grid(width, height, tiles);
  }
}

void part1() {
  final fileContents = readInputFile(2024, 10, "input");
  final parsedGrid = Grid.parse(fileContents);
  final foundPaths = parsedGrid.calculatePaths();

  final Map<Position, Set<Position>> endPositionsForPositions = {};

  for (var foundPath in foundPaths) {
    final startPosition = foundPath.first;
    final currentEndPositions = endPositionsForPositions[startPosition] ?? {};
    endPositionsForPositions[startPosition] = {
      ...currentEndPositions,
      foundPath.last
    };
  }

  final result = endPositionsForPositions.values
      .fold(0, (acc, score) => acc + score.length);

  print("Result: $result");
}

void part2() {
  final fileContents = readInputFile(2024, 10, "input");
  final parsedGrid = Grid.parse(fileContents);
  final foundPaths = parsedGrid.calculatePaths();

  final Map<Position, int> ratings = {};

  for (var foundPath in foundPaths) {
    final startPosition = foundPath.first;
    final currentRating = ratings[startPosition] ?? 0;
    ratings[startPosition] = currentRating + 1;
  }

  final result = ratings.values.fold(0, (acc, score) => acc + score);

  print("Result: $result");
}
