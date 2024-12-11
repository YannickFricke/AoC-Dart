import 'package:advent_of_code/utils.dart';

typedef Position = ({int x, int y});

class Grid {
  List<List<String?>> tiles;

  Grid(this.tiles);

  Position get dimensions => (x: tiles[0].length, y: tiles.length);

  @override
  String toString() {
    return 'Grid{tiles: $tiles}';
  }

  Map<String, List<Position>> getAntennaPositions() {
    final result = <String, List<Position>>{};

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

  void printGridWithAntinodes(Set<Position> antinodes) {
    for (var y = 0; y < tiles.length; y++) {
      final rowCharacters = <String>[];

      for (var x = 0; x < tiles[y].length; x++) {
        final Position currentPosition = (x: x, y: y);

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

  bool isPositionInGrid(Position positionToCheck) {
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

Set<Position> calculateAntinodePositions(
  List<Position> positions,
  Grid? grid,
) {
  final result = <Position>{};

  for (var currentIndex = 0; currentIndex < positions.length; currentIndex++) {
    for (var otherIndex = 0; otherIndex < positions.length; otherIndex++) {
      if (otherIndex == currentIndex) {
        continue;
      }

      final currentPosition = positions[currentIndex];
      final otherPosition = positions[otherIndex];

      final Position offset = (
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
        <Position>{},
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
        <Position>{},
        (acc, antinodePositions) => {...acc, ...antinodePositions},
      )
      .where(parsedGrid.isPositionInGrid)
      .toSet();

  parsedGrid.printGridWithAntinodes(allAntinodePositions);

  print("Result: ${allAntinodePositions.length}");
}
