import 'package:advent_of_code/utils.dart';

enum Direction {
  top,
  topRight,
  right,
  bottomRight,
  bottom,
  bottomLeft,
  left,
  topLeft;
}

class FoundMatch {
  final Direction direction;

  final int startLine;
  final int startColumn;

  final int endLine;
  final int endColumn;

  const FoundMatch(
    this.direction,
    this.startLine,
    this.startColumn,
    this.endLine,
    this.endColumn,
  );

  @override
  bool operator ==(Object other) {
    if (other is! FoundMatch) {
      return false;
    }

    return direction == other.direction &&
        startLine == other.startLine &&
        startColumn == other.startColumn &&
        endLine == other.endLine &&
        endColumn == other.endColumn;
  }

  @override
  int get hashCode =>
      Object.hash(direction, startLine, startColumn, endLine, endColumn);

  @override
  String toString() {
    return 'FoundMatch{direction: $direction, startLine: $startLine, startColumn: $startColumn, endLine: $endLine, endColumn: $endColumn}';
  }
}

List<(int, int)> calculateDiagonalIndexes(
  int lineIndex,
  int columnIndex,
  int wordLength,
  int lineMultiplicator,
  int columnMultiplicator,
) {
  final foundIndexes = <(int, int)>[];

  final targetLineIndex = lineIndex + ((wordLength - 1) * lineMultiplicator);
  var lineIndexToWorkWith = lineIndex;
  var columnIndexToWorkWith = columnIndex;

  while (lineIndexToWorkWith != targetLineIndex + lineMultiplicator) {
    foundIndexes.add((lineIndexToWorkWith, columnIndexToWorkWith));

    lineIndexToWorkWith += lineMultiplicator;
    columnIndexToWorkWith += columnMultiplicator;
  }

  return foundIndexes;
}

List<FoundMatch> findMatches(List<List<String>> lines, String wordToFind) {
  final foundMatches = <FoundMatch>[];

  for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
    final row = lines[lineIndex];

    for (var columnIndex = 0; columnIndex < row.length; columnIndex++) {
      final currentCharacter = lines[lineIndex][columnIndex];

      if (currentCharacter != wordToFind[0]) {
        continue;
      }

      if (lineIndex >= wordToFind.length - 1) {
        // Check if we can find the word to the top direction
        final foundWord = lines
            .skip(lineIndex + 1 - wordToFind.length)
            .take(wordToFind.length)
            .map((line) => line[columnIndex])
            .toList()
            .reversed
            .join("");

        if (foundWord == wordToFind) {
          foundMatches.add(
            FoundMatch(
              Direction.top,
              lineIndex,
              columnIndex,
              lineIndex + 1 - wordToFind.length,
              columnIndex,
            ),
          );
        }
      }

      if (lineIndex >= wordToFind.length - 1 &&
          columnIndex <= row.length - wordToFind.length) {
        // Check if we can find the word to the top-right direction
        final foundWord = calculateDiagonalIndexes(
                lineIndex, columnIndex, wordToFind.length, -1, 1)
            .map((tuple) => lines[tuple.$1][tuple.$2])
            .join("");

        if (foundWord == wordToFind) {
          foundMatches.add(
            FoundMatch(
              Direction.topRight,
              lineIndex,
              columnIndex,
              lineIndex + 1 - wordToFind.length,
              columnIndex + wordToFind.length - 1,
            ),
          );
        }
      }

      if (columnIndex <= row.length - wordToFind.length) {
        // Check if the word fits the right side

        final foundWord =
            row.skip(columnIndex).take(wordToFind.length).join("");

        if (foundWord == wordToFind) {
          foundMatches.add(
            FoundMatch(
              Direction.right,
              lineIndex,
              columnIndex,
              lineIndex,
              columnIndex + wordToFind.length,
            ),
          );
        }
      }

      if (lineIndex <= lines.length - wordToFind.length &&
          columnIndex <= row.length - wordToFind.length) {
        // Check if we can find the word to the bottom-right direction

        final foundWord = calculateDiagonalIndexes(
          lineIndex,
          columnIndex,
          wordToFind.length,
          1,
          1,
        ).map((tuple) => lines[tuple.$1][tuple.$2]).join("");

        if (foundWord == wordToFind) {
          foundMatches.add(
            FoundMatch(
              Direction.bottomRight,
              lineIndex,
              columnIndex,
              lineIndex + wordToFind.length - 1,
              columnIndex + wordToFind.length - 1,
            ),
          );
        }
      }

      if (lineIndex <= lines.length - wordToFind.length) {
        // Check if we can find the word to the bottom direction

        final foundWord = lines
            .skip(lineIndex)
            .take(wordToFind.length)
            .map((row) => row[columnIndex])
            .join("");

        if (foundWord == wordToFind) {
          foundMatches.add(
            FoundMatch(
              Direction.bottom,
              lineIndex,
              columnIndex,
              lineIndex + wordToFind.length - 1,
              columnIndex,
            ),
          );
        }
      }

      if (lineIndex <= lines.length - wordToFind.length &&
          columnIndex >= wordToFind.length - 1) {
        // Check if we can find the word to the bottom-left direction
        final foundWord = calculateDiagonalIndexes(
                lineIndex, columnIndex, wordToFind.length, 1, -1)
            .map((tuple) => lines[tuple.$1][tuple.$2])
            .join("");

        if (foundWord == wordToFind) {
          foundMatches.add(
            FoundMatch(
              Direction.bottomLeft,
              lineIndex,
              columnIndex,
              lineIndex + wordToFind.length - 1,
              columnIndex + 1 - wordToFind.length,
            ),
          );
        }
      }

      if (columnIndex >= wordToFind.length - 1) {
        // Check if we can find the word to the left direction
        final foundWord = row
            .skip(columnIndex - wordToFind.length + 1)
            .take(wordToFind.length)
            .toList()
            .reversed
            .join("");

        if (foundWord == wordToFind) {
          foundMatches.add(
            FoundMatch(
              Direction.left,
              lineIndex,
              columnIndex + 1,
              lineIndex,
              columnIndex + 1 - wordToFind.length,
            ),
          );
        }
      }

      if (columnIndex >= wordToFind.length - 1 &&
          lineIndex >= wordToFind.length - 1) {
        // Check if we can find the word to the top-left direction
        final foundWord = calculateDiagonalIndexes(
                lineIndex, columnIndex, wordToFind.length, -1, -1)
            .map((tuple) => lines[tuple.$1][tuple.$2])
            .join();

        if (foundWord == wordToFind) {
          foundMatches.add(
            FoundMatch(
              Direction.topLeft,
              lineIndex,
              columnIndex,
              lineIndex + 1 - wordToFind.length,
              columnIndex + 1 - wordToFind.length,
            ),
          );
        }
      }
    }
  }

  return foundMatches;
}

void part1() {
  final input = readInputFile(2024, 4, "input")
      .split("\n")
      .map((row) => row.split(""))
      .toList();

  final foundMatches = findMatches(input, "XMAS");

  print("Result: ${foundMatches.length}");
}

void part2() {
  final input = readInputFile(2024, 4, "input")
      .split("\n")
      .map((row) => row.split(""))
      .toList();

  final wordToFind = "MAS";

  final foundMatches = findMatches(input, wordToFind)
      .where((match) =>
          match.direction == Direction.topLeft ||
          match.direction == Direction.topRight ||
          match.direction == Direction.bottomLeft ||
          match.direction == Direction.bottomRight)
      .toList();

  final result = foundMatches.fold(0, (acc, match) {
    switch (match.direction) {
      case Direction.topLeft:
        final hasOverlappingMatch = foundMatches.any((otherMatch) {
          switch (otherMatch.direction) {
            case Direction.topRight:
              return match.startLine == otherMatch.startLine &&
                  match.endLine == otherMatch.endLine &&
                  match.startColumn == otherMatch.endColumn &&
                  match.endColumn == otherMatch.startColumn;
            case Direction.bottomLeft:
              return match.startLine == otherMatch.endLine &&
                  match.endLine == otherMatch.startLine &&
                  match.startColumn == otherMatch.startColumn &&
                  match.endColumn == otherMatch.endColumn;
            default:
              return false;
          }
        });

        return hasOverlappingMatch ? acc + 1 : acc;

      case Direction.topRight:
        final hasOverlappingMatch = foundMatches.any((otherMatch) {
          switch (otherMatch.direction) {
            case Direction.topLeft:
              return match.startLine == otherMatch.startLine &&
                  match.endLine == otherMatch.endLine &&
                  match.startColumn == otherMatch.endColumn &&
                  match.endColumn == otherMatch.startColumn;
            case Direction.bottomRight:
              return match.startLine == otherMatch.endLine &&
                  match.endLine == otherMatch.startLine &&
                  match.startColumn == otherMatch.startColumn &&
                  match.endColumn == otherMatch.endColumn;
            default:
              return false;
          }
        });

        return hasOverlappingMatch ? acc + 1 : acc;

      case Direction.bottomLeft:
        final hasOverlappingMatch = foundMatches.any((otherMatch) {
          switch (otherMatch.direction) {
            case Direction.bottomRight:
              return match.startLine == otherMatch.startLine &&
                  match.endLine == otherMatch.endLine &&
                  match.startColumn == otherMatch.endColumn &&
                  match.endColumn == otherMatch.startColumn;

            case Direction.topLeft:
              return match.startLine == otherMatch.endLine &&
                  match.endLine == otherMatch.startLine &&
                  match.startColumn == otherMatch.startColumn &&
                  match.endColumn == otherMatch.endColumn;

            default:
              return false;
          }
        });

        return hasOverlappingMatch ? acc + 1 : acc;

      case Direction.bottomRight:
        final hasOverlappingMatch = foundMatches.any((otherMatch) {
          switch (otherMatch.direction) {
            case Direction.bottomLeft:
              return match.startLine == otherMatch.startLine &&
                  match.endLine == otherMatch.endLine &&
                  match.startColumn == otherMatch.endColumn &&
                  match.endColumn == otherMatch.startColumn;

            case Direction.topRight:
              return match.startLine == otherMatch.endLine &&
                  match.endLine == otherMatch.startLine &&
                  match.startColumn == otherMatch.startColumn &&
                  match.endColumn == otherMatch.endColumn;

            default:
              return false;
          }
        });

        return hasOverlappingMatch ? acc + 1 : acc;

      default:
        return acc;
    }
  });

  print("Result: ${result / 2}");
}
