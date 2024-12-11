import 'package:advent_of_code/2024/day04.dart';
import 'package:test/test.dart';

void main() {
  final wordToFind = "XMAS";

  group('calculateDiagonalIndexes', () {
    test('should calculate the correct indexes for top-left', () {
      final result = calculateDiagonalIndexes(
        3,
        3,
        4,
        -1,
        -1,
      );

      expect(result, [
        (3, 3),
        (2, 2),
        (1, 1),
        (0, 0),
      ]);
    });

    test('should calculate the correct indexes for top-right', () {
      final result = calculateDiagonalIndexes(
        3,
        0,
        4,
        -1,
        1,
      );

      expect(result, [
        (3, 0),
        (2, 1),
        (1, 2),
        (0, 3),
      ]);
    });

    test('should calculate the correct indexes for bottom-right', () {
      final result = calculateDiagonalIndexes(
        3,
        3,
        4,
        1,
        1,
      );

      expect(result, [
        (3, 3),
        (4, 4),
        (5, 5),
        (6, 6),
      ]);
    });

    test('should calculate the correct indexes for bottom-left', () {
      final result = calculateDiagonalIndexes(
        3,
        3,
        4,
        1,
        -1,
      );

      expect(result, [
        (3, 3),
        (4, 2),
        (5, 1),
        (6, 0),
      ]);
    });

    test('should calculate the correct indexes for top-right', () {});

    test('should calculate the correct indexes for bottom-left', () {});

    test('should calculate the correct indexes for bottom-right', () {});
  });

  group('findMatches', () {
    group('horizontal', () {
      test('should find all right matches', () {
        final input = [
          [".", "X", "M", "A", "S", "."],
        ];
        final result = findMatches(input, wordToFind);

        expect(result, [
          FoundMatch(Direction.right, 0, 1, 0, 5),
        ]);
      });

      test('should find all left matches', () {
        final input = [
          [".", "S", "A", "M", "X", "."],
        ];
        final result = findMatches(input, wordToFind);

        expect(result, [
          FoundMatch(Direction.left, 0, 5, 0, 1),
        ]);
      });
    });

    group('vertical', () {
      test('should find all top matches', () {
        final input = [
          [".", ".", "."], // 0
          [".", "S", "."], // 1
          [".", "A", "."], // 2
          [".", "M", "."], // 3
          [".", "X", "."], // 4
          [".", ".", "."], // 5
        ];

        final result = findMatches(input, wordToFind);

        expect(result, [
          FoundMatch(Direction.top, 4, 1, 1, 1),
        ]);
      });

      test('should find all bottom matches', () {
        final input = [
          [".", ".", "."], // 0
          [".", "X", "."], // 1
          [".", "M", "."], // 2
          [".", "A", "."], // 3
          [".", "S", "."], // 4
          [".", ".", "."], // 5
        ];

        final result = findMatches(input, wordToFind);

        expect(result, [
          FoundMatch(Direction.bottom, 1, 1, 4, 1),
        ]);
      });
    });

    group('diagonal', () {
      group('top', () {
        test(
          'should find all matches to the top-left of the current index',
          () {
            final input = [
              ["S", ".", ".", "."], // 0
              [".", "A", ".", "."], // 1
              [".", ".", "M", "."], // 2
              [".", ".", ".", "X"], // 3
            ];
            final result = findMatches(input, wordToFind);

            expect(result, [
              FoundMatch(Direction.topLeft, 3, 3, 0, 0),
            ]);
          },
        );

        test(
          'should find all matches to the top-right of the current index',
          () {
            final input = [
              [".", ".", ".", "S"], // 0
              [".", ".", "A", "."], // 1
              [".", "M", ".", "."], // 2
              ["X", ".", ".", "."], // 3
            ];
            final result = findMatches(input, wordToFind);

            expect(result, [
              FoundMatch(Direction.topLeft, 3, 0, 0, 3),
            ]);
          },
        );
      });

      group('bottom', () {
        test(
          'should find all matches to the bottom-right of the current index',
          () {
            final input = [
              [".", ".", ".", "."], // 0
              ["X", ".", ".", "."], // 1
              [".", "M", ".", "."], // 2
              [".", ".", "A", "."], // 3
              [".", ".", ".", "S"], // 4
              [".", ".", ".", "."], // 5
            ];

            final result = findMatches(input, wordToFind);

            expect(result, [
              FoundMatch(Direction.bottomRight, 1, 0, 4, 3),
            ]);
          },
        );

        test(
          'should find all matches to the bottom-left of the current index',
          () {
            final input = [
              [".", ".", ".", "."], // 0
              [".", ".", ".", "X"], // 1
              [".", ".", "M", "."], // 2
              [".", "A", ".", "."], // 3
              ["S", ".", ".", "."], // 4
              [".", ".", ".", "."], // 5
            ];

            final result = findMatches(input, wordToFind);

            expect(result, [
              FoundMatch(Direction.bottomLeft, 1, 3, 4, 0),
            ]);
          },
        );
      });
    });
  });
}
