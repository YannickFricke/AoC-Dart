import 'package:advent_of_code/ansi_color.dart';
import 'package:advent_of_code/base_grid.dart';
import 'package:advent_of_code/direction.dart';
import 'package:advent_of_code/utils.dart';
import 'package:advent_of_code/vector.dart';

class Grid extends BaseGrid<int> {
  Grid(super.tiles);

  @override
  String toString() {
    return 'Grid{width: $width, height: $height, tiles: $tiles}';
  }

  List<Vector2> getStartPositions() {
    final result = <Vector2>[];

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

  List<Vector2> calculateNeighbors(Vector2 currentPosition) {
    final result = <Vector2>[];

    for (var direction in Direction.cardinal) {
      final positionWithOffset = addVector2(currentPosition, direction.offset);

      if (isPositionInGrid(positionWithOffset) == false) {
        continue;
      }

      result.add(positionWithOffset);
    }

    return result;
  }

  List<Set<Vector2>> calculatePaths() {
    final result = <Set<Vector2>>[];
    final startPositions = getStartPositions();

    for (var startPosition in startPositions) {
      result.addAll(calculatePathFromPosition(startPosition));
    }

    return result;
  }

  List<Set<Vector2>> calculatePathFromPosition(Vector2 startPosition) {
    final result = <Set<Vector2>>[];
    final pathsToFollow = <Set<Vector2>>[
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

  int getHeightForPosition(Vector2 position) => tiles[position.y][position.x];

  void printPath(Set<Vector2> path) {
    for (var y = 0; y < height; y++) {
      final row = <String>[];

      for (var x = 0; x < width; x++) {
        final Vector2 currentPosition = (x: x, y: y);
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
    final tiles = <List<int>>[];

    final lines = input.split("\n");

    for (var line in lines) {
      final row = <int>[];

      for (var character in line.split("")) {
        row.add(int.parse(character));
      }

      tiles.add(row);
    }

    return Grid(tiles);
  }
}

void part1() {
  final fileContents = readInputFile(2024, 10, "input");
  final parsedGrid = Grid.parse(fileContents);
  final foundPaths = parsedGrid.calculatePaths();

  final Map<Vector2, Set<Vector2>> endPositionsForPositions = {};

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

  final Map<Vector2, int> ratings = {};

  for (var foundPath in foundPaths) {
    final startPosition = foundPath.first;
    final currentRating = ratings[startPosition] ?? 0;
    ratings[startPosition] = currentRating + 1;
  }

  final result = ratings.values.fold(0, (acc, score) => acc + score);

  print("Result: $result");
}
