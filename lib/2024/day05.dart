import 'package:advent_of_code/utils.dart';

List<int> addNumber(
  List<int> rowResult,
  Iterable<(int, int)> orderingRules,
  int numberToAdd,
) {
  if (rowResult.contains(numberToAdd)) {
    return rowResult;
  }

  final rulesForElement = orderingRules.where(
    (element) => element.$2 == numberToAdd,
  );

  var tempResult = rowResult;

  for (var rule in rulesForElement) {
    tempResult = addNumber(tempResult, orderingRules, rule.$1);
  }

  return [...tempResult, numberToAdd];
}

(List<(int, int)>, List<List<int>>) parseData(String input) {
  final [rawOrderingRules, rawPageUpdates] = input.split("\n\n");

  final orderingRules = rawOrderingRules.split("\n").map((line) {
    final [lhs, rhs] = line.split("|");

    return (int.parse(lhs), int.parse(rhs));
  }).toList();

  final pageUpdates = rawPageUpdates
      .split("\n")
      .map(
        (line) => line.split(",").map(int.parse).toList(),
      )
      .toList();

  return (orderingRules, pageUpdates);
}

int getMiddleValue(List<int> numbers) {
  return numbers.elementAt((numbers.length / 2).floor());
}

int calculateMiddleValueSum(List<List<int>> numbers) {
  return numbers.fold(0, (acc, row) => acc + getMiddleValue(row));
}

void part1() {
  final fileContents = readFile("./inputs/2024day05/input.txt");
  final (orderingRules, pageUpdates) = parseData(fileContents);
  final validPageUpdates = <List<int>>[];

  for (var pageUpdate in pageUpdates) {
    final orderingRulesForCurrentLine = orderingRules.where(
      (rule) => pageUpdate.contains(rule.$1) && pageUpdate.contains(rule.$2),
    );

    final isCorrectlyOrdered = pageUpdate.indexed.every((entry) {
      final currentIndex = entry.$1;
      final currentNumber = entry.$2;
      final previousValues = pageUpdate.take(currentIndex);
      final rulesForCurrentNumber =
          orderingRulesForCurrentLine.where((rule) => rule.$2 == currentNumber);

      return rulesForCurrentNumber
          .every((rule) => previousValues.contains(rule.$1));
    });

    if (isCorrectlyOrdered) {
      validPageUpdates.add(pageUpdate);
    }
  }

  print("Result: ${calculateMiddleValueSum(validPageUpdates)}");
}

void part2() {
  final fileContents = readFile("./inputs/2024day05/input.txt");
  final (orderingRules, pageUpdates) = parseData(fileContents);
  final invalidPageUpdates = <List<int>>[];

  for (var pageUpdate in pageUpdates) {
    final orderingRulesForCurrentLine = orderingRules.where(
      (rule) => pageUpdate.contains(rule.$1) && pageUpdate.contains(rule.$2),
    );

    final isCorrectlyOrdered = pageUpdate.indexed.every((entry) {
      final currentIndex = entry.$1;
      final currentNumber = entry.$2;
      final previousValues = pageUpdate.take(currentIndex);
      final rulesForCurrentNumber =
          orderingRulesForCurrentLine.where((rule) => rule.$2 == currentNumber);

      return rulesForCurrentNumber
          .every((rule) => previousValues.contains(rule.$1));
    });

    if (isCorrectlyOrdered == false) {
      invalidPageUpdates.add(pageUpdate);
    }
  }

  final correctedPageUpdates = <List<int>>[];

  for (var invalidPageUpdate in invalidPageUpdates) {
    var rowResult = <int>[];

    final orderingRulesForRow = orderingRules.where(
      (element) =>
          invalidPageUpdate.contains(element.$1) &&
          invalidPageUpdate.contains(element.$2),
    );

    for (var number in invalidPageUpdate) {
      rowResult = addNumber(rowResult, orderingRulesForRow, number);
    }

    correctedPageUpdates.add(rowResult);
  }

  print("Result: ${calculateMiddleValueSum(correctedPageUpdates)}");
}
