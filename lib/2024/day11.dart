import 'package:advent_of_code/utils.dart';

Map<int, int> parseLine(String line) {
  return line
      .split(" ")
      .where((entry) => entry.isNotEmpty)
      .map(int.parse)
      .fold({}, (acc, number) => {...acc, number: 1});
}

Map<int, int> blink(Map<int, int> stones) {
  final Map<int, int> result = {};

  for (var mapEntry in stones.entries) {
    final numberParts = mapEntry.key.toString().split("");

    if (mapEntry.key == 0) {
      result[1] = (result[1] ?? 0) + mapEntry.value;
    } else if (numberParts.length % 2 == 0) {
      final lhs = int.parse(numberParts.take(numberParts.length ~/ 2).join());
      final rhs = int.parse(numberParts.skip(numberParts.length ~/ 2).join());

      result[lhs] = (result[lhs] ?? 0) + mapEntry.value;
      result[rhs] = (result[rhs] ?? 0) + mapEntry.value;
    } else {
      result[mapEntry.key * 2024] =
          (result[mapEntry.key * 2024] ?? 0) + mapEntry.value;
    }
  }

  return result;
}

void part1() {
  final result =
      readInputFile(2024, 11, "input").split("\n").map(parseLine).map((line) {
    var result = line;

    for (var i = 0; i < 25; i++) {
      result = blink(result);
    }

    return result.values.fold(0, (acc, amount) => acc + amount);
  });

  print("Result: $result");
}

void part2() {
  final result =
      readInputFile(2024, 11, "input").split("\n").map(parseLine).map((line) {
    var result = line;

    for (var i = 0; i < 75; i++) {
      result = blink(result);
    }

    return result.values.fold(0, (acc, amount) => acc + amount);
  });

  print("Result: $result");
}
