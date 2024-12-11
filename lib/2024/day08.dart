import 'package:advent_of_code/utils.dart';
import 'package:advent_of_code/vector.dart';

class Grid {
  List<List<String?>> tiles;

  Grid(this.tiles);

  Vector2 get dimensions => (x: tiles[0].length, y: tiles.length);

  @override
  String toString() {
    return 'Grid{tiles: $tiles}';
  }

  Map<String, List<Vector2>> getAntennaPositions() {
    final result = <String, List<Vector2>>{};

    for (var y = 0; y < tiles.length; y++) {
      final currentRow = tiles[y];

      for (var x = 0; x < currentRow.length; x++) {
        switch (currentRow[x]) {
          case null:
            break;
          case var antennaCharacter:
            final existingPositions = result[antennaCharacter] ?? [];
            result[antennaCharacter] = [...existingPositions, (x: x, y: y)];

            break;
        }
      }
    }

    return result;
  }

  void printGrid() => printGridWithAntinodes({});

  void printGridWithAntinodes(Set<Vector2> antinodes) {
    for (var y = 0; y < tiles.length; y++) {
      final rowCharacters = <String>[];

      for (var x = 0; x < tiles[y].length; x++) {
        final Vector2 currentPosition = (x: x, y: y);

        switch (tiles[y][x]) {
          case null:
            rowCharacters.add(antinodes.contains(currentPosition) ? "#" : ".");
            break;
          case var antennaCharacter:
            rowCharacters.add(antennaCharacter);
            break;
        }
      }

      print(rowCharacters.join(""));
    }
  }

  bool isPositionInGrid(Vector2 positionToCheck) {
    if (positionToCheck.y < 0) {
      return false;
    }

    if (positionToCheck.y >= tiles.length) {
      return false;
    }

    if (positionToCheck.x < 0) {
      return false;
    }

    if (positionToCheck.x >= tiles[positionToCheck.y].length) {
      return false;
    }

    return true;
  }

  static Grid parseInput(String input) {
    final tiles = input
        .split("\n")
        .map(
          (line) => line
              .split("")
              .where(
                (column) => column.isNotEmpty,
              )
              .map((column) => column == "." ? null : column)
              .toList(),
        )
        .toList();

    return Grid(tiles);
  }
}

Set<Vector2> calculateAntinodePositions(
  List<Vector2> positions,
  Grid? grid,
) {
  final result = <Vector2>{};

  for (var currentIndex = 0; currentIndex < positions.length; currentIndex++) {
    for (var otherIndex = 0; otherIndex < positions.length; otherIndex++) {
      if (otherIndex == currentIndex) {
        continue;
      }

      final currentPosition = positions[currentIndex];
      final otherPosition = positions[otherIndex];

      final Vector2 offset = (
        x: otherPosition.x - currentPosition.x,
        y: otherPosition.y - currentPosition.y,
      );

      var calculatedPosition = (
        x: currentPosition.x - offset.x,
        y: currentPosition.y - offset.y,
      );

      if (grid == null) {
        result.add(calculatedPosition);

        continue;
      }

      result.add(currentPosition);

      while (grid.isPositionInGrid(calculatedPosition)) {
        result.add(calculatedPosition);

        calculatedPosition = (
          x: calculatedPosition.x - offset.x,
          y: calculatedPosition.y - offset.y,
        );
      }
    }
  }

  return result;
}

void part1() {
  final fileContents = readInputFile(2024, 8, "test");
  final parsedGrid = Grid.parseInput(fileContents);
  final antennaPositions = parsedGrid.getAntennaPositions();
  final allAntinodePositions = antennaPositions.values
      .map((antennaPosition) =>
          calculateAntinodePositions(antennaPosition, null))
      .fold(
        <Vector2>{},
        (acc, antinodePositions) => {...acc, ...antinodePositions},
      )
      .where(parsedGrid.isPositionInGrid)
      .toSet();

  print(allAntinodePositions);

  print("Result: ${allAntinodePositions.length}");
}

void part2() {
  final fileContents = readInputFile(2024, 8, "input");
  final parsedGrid = Grid.parseInput(fileContents);
  final antennaPositions = parsedGrid.getAntennaPositions();
  final allAntinodePositions = antennaPositions.values
      .map((antennaPosition) => calculateAntinodePositions(
            antennaPosition,
            parsedGrid,
          ))
      .fold(
        <Vector2>{},
        (acc, antinodePositions) => {...acc, ...antinodePositions},
      )
      .where(parsedGrid.isPositionInGrid)
      .toSet();

  parsedGrid.printGridWithAntinodes(allAntinodePositions);

  print("Result: ${allAntinodePositions.length}");
}
