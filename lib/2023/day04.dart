import 'dart:math';

import 'package:advent_of_code/utils.dart';

final cardRegex = RegExp(
  r'Card\s+(?<cardNumber>\d+): (?<winningNumbers>.*)\|(?<ourNumbers>.*)',
);

class Card {
  Set<int> winningNumbers;
  Set<int> ourNumbers;

  Card(this.winningNumbers, this.ourNumbers);

  int matchingNumbers() => ourNumbers
      .where(
        (number) => winningNumbers.contains(number),
      )
      .length;

  int calculatePoints() {
    switch (matchingNumbers()) {
      case 1:
        return 1;
      case var amountOfMatchingNumbers:
        return pow(2, amountOfMatchingNumbers - 1).toInt();
    }
  }

  static (int, Card) parse(String line) {
    final match = cardRegex.firstMatch(line)!;

    final cardNumber = int.parse(match.namedGroup("cardNumber")!);

    final winningNumbers = match
        .namedGroup("winningNumbers")!
        .split(" ")
        .where((element) => element.isNotEmpty)
        .map(int.parse)
        .toSet();

    final ourNumbers = match
        .namedGroup("ourNumbers")!
        .split(" ")
        .where((element) => element.isNotEmpty)
        .map(int.parse)
        .toSet();

    return (cardNumber, Card(winningNumbers, ourNumbers));
  }

  @override
  String toString() {
    return 'Card{winningNumbers: $winningNumbers, ourNumbers: $ourNumbers}';
  }
}

void part1() {
  final result = readInputFile(
    2023,
    4,
    "input",
  )
      .split("\n")
      .map(Card.parse)
      .fold(0, (acc, card) => acc + card.$2.calculatePoints());

  print("Result: $result");
}

void part2() {
  final cards = readInputFile(
    2023,
    4,
    "input",
  ).split("\n").map(Card.parse);

  var cardMap = <int, int>{};

  // ignore: unused_local_variable
  for (var (cardNumber, card) in cards) {
    cardMap[cardNumber] = 1;
  }

  for (var (cardNumber, card) in cards) {
    print("Processing card number: $cardNumber");

    final amountOfAffectedCards = card.matchingNumbers();

    for (var i = 0; i < cardMap[cardNumber]!; i++) {
      for (var j = cardNumber + 1;
          j < cardNumber + amountOfAffectedCards + 1;
          j++) {
        if (cardMap.containsKey(j) == false) {
          continue;
        }

        cardMap[j] = cardMap[j]! + 1;
      }
    }
  }

  final result = cardMap.values.fold(0, (acc, value) => acc + value);

  print("Result: $result");
}
