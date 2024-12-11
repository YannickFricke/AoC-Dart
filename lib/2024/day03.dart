import 'package:advent_of_code/utils.dart';

void part1() {
  final lines = readInputFile(2024, 3, "input").split("\n");
  final regex = RegExp(r'mul\((?<lhs>\d{1,3})\s*,(?<rhs>\d{1,3})\)');

  final foundNumbers = <int>[];

  for (var line in lines) {
    final matches = regex.allMatches(line);

    for (var match in matches) {
      final rawLhs = match.namedGroup("lhs")!;
      final rawRhs = match.namedGroup("rhs")!;

      final parsedLhs = int.parse(rawLhs);
      final parsedRhs = int.parse(rawRhs);

      foundNumbers.add(parsedLhs * parsedRhs);
    }
  }

  final result = foundNumbers.fold(0, (acc, number) => acc + number);

  print("Result: $result");
}

void part2() {
  final input = readInputFile(2024, 3, "input").split("\n").join("");
  final regex = RegExp(
    r"(mul\((?<lhs>\d{1,3})\s*,(?<rhs>\d{1,3})\)|do\(\)|don't\(\))",
  );

  final matches = regex.allMatches(input);
  final foundNumbers = <int>[];
  var shouldSkip = false;

  for (var match in matches) {
    switch (match.group(0)!) {
      case "do()":
        shouldSkip = false;
        break;
      case "don't()":
        shouldSkip = true;
        break;
      default:
        if (shouldSkip) {
          break;
        }

        final rawLhs = match.namedGroup("lhs")!;
        final rawRhs = match.namedGroup("rhs")!;

        final parsedLhs = int.parse(rawLhs);
        final parsedRhs = int.parse(rawRhs);

        foundNumbers.add(parsedLhs * parsedRhs);
        break;
    }
  }

  final result = foundNumbers.fold(0, (acc, number) => acc + number);

  print("Result: $result");
}
