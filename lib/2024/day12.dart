import 'package:advent_of_code/base_grid.dart';
import 'package:advent_of_code/direction.dart';
import 'package:advent_of_code/utils.dart';
import 'package:advent_of_code/vector.dart';

typedef Region = ({String character, Set<Vector2> positions});

int calculateRegionArea(Region region) => region.positions.length;

class Grid extends BaseGrid<String> {
  Grid(super.tiles);

  List<Region> extractRegions() {
    final foundRegions = <Region>[];
    final processedPositions = <Vector2>{};

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final currentCharacter = tiles[y][x];
        final Vector2 currentPosition = (x: x, y: y);

        if (processedPositions.contains(currentPosition)) {
          continue;
        }

        final regionPositions = <Vector2>{};
        final regionPositionsToCheck = <Vector2>{currentPosition};

        while (regionPositionsToCheck.isNotEmpty) {
          final currentRegionPosition = regionPositionsToCheck.first;
          regionPositionsToCheck.remove(currentRegionPosition);

          if (regionPositions.contains(currentRegionPosition)) {
            continue;
          }

          final tileCharacter = getTileForPosition(currentRegionPosition);

          if (currentCharacter != tileCharacter) {
            continue;
          }

          final neighbors = Direction.cardinal.map((direction) => addVector2(
                currentRegionPosition,
                direction.offset,
              ));

          regionPositionsToCheck.addAll(neighbors);

          regionPositions.add(currentRegionPosition);
          processedPositions.add(currentRegionPosition);
        }

        foundRegions
            .add((character: currentCharacter, positions: regionPositions));
      }
    }

    return foundRegions;
  }

  int calculatePerimeterForRegion(Region region) {
    final temp = <Vector2, int>{};

    for (var position in region.positions) {
      final neighbors = Direction.cardinal
          .map((direction) => addVector2(position, direction.offset))
          .where((neighborPosition) =>
              region.positions.contains(neighborPosition) == false);

      for (var neighbor in neighbors) {
        temp.update(
          neighbor,
          (amount) => amount + 1,
          ifAbsent: () => 1,
        );
      }
    }

    return temp.values.fold(0, (acc, amount) => acc + amount);
  }

  int calculateCornersForRegion(Region region) {
    var foundCorners = 0;

    for (var position in region.positions) {
      final up = addVector2(position, Direction.up.offset);
      final upRight = addVector2(position, Direction.upRight.offset);
      final right = addVector2(position, Direction.right.offset);
      final downRight = addVector2(position, Direction.downRight.offset);
      final down = addVector2(position, Direction.down.offset);
      final downLeft = addVector2(position, Direction.downLeft.offset);
      final left = addVector2(position, Direction.left.offset);
      final upLeft = addVector2(position, Direction.upLeft.offset);

      final isUp = region.positions.contains(up);
      final isUpRight = region.positions.contains(upRight);
      final isRight = region.positions.contains(right);
      final isDownRight = region.positions.contains(downRight);
      final isDown = region.positions.contains(down);
      final isDownLeft = region.positions.contains(downLeft);
      final isLeft = region.positions.contains(left);
      final isUpLeft = region.positions.contains(upLeft);

      if (isUp) {
        if (isLeft && isUpLeft == false) {
          foundCorners++;
        }
        if (isRight && isUpRight == false) {
          foundCorners++;
        }
      } else {
        if (isLeft == false) {
          foundCorners++;
        }

        if (isRight == false) {
          foundCorners++;
        }
      }

      if (isDown) {
        if (isLeft && isDownLeft == false) {
          foundCorners++;
        }

        if (isRight && isDownRight == false) {
          foundCorners++;
        }
      } else {
        if (isLeft == false) {
          foundCorners++;
        }

        if (isRight == false) {
          foundCorners++;
        }
      }
    }

    return foundCorners;
  }

  @override
  String toString() => "Grid{tiles: $tiles}";

  static Grid parse(String input) {
    final tiles = input
        .split("\n")
        .map(
          (line) => line.split("").toList(),
        )
        .toList();

    return Grid(tiles);
  }
}

void part1() {
  final fileContents = readInputFile(2024, 12, "input");
  final parsedGrid = Grid.parse(fileContents);
  final regions = parsedGrid.extractRegions();

  var result = 0;

  for (var i = 0; i < regions.length; i++) {
    final region = regions[i];
    final area = calculateRegionArea(region);
    final perimeter = parsedGrid.calculatePerimeterForRegion(region);

    result += area * perimeter;
  }

  print("Result: $result");
}

void part2() {
  final fileContents = readInputFile(2024, 12, "input");
  final parsedGrid = Grid.parse(fileContents);
  final regions = parsedGrid.extractRegions();

  var result = 0;

  for (var i = 0; i < regions.length; i++) {
    final region = regions[i];
    final area = calculateRegionArea(region);
    final corners = parsedGrid.calculateCornersForRegion(region);

    result += area * corners;
  }

  print("Result: $result");
}
