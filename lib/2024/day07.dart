import 'package:advent_of_code/utils.dart';

enum Operation {
  add,
  multiply,
  concat,
}

class NumberNode {
  int value;
  List<OperationNode> children;

  NumberNode(int value) : this.withChildren(value, []);

  NumberNode.withChildren(this.value, this.children);

  @override
  String toString() {
    return 'NumberNode{value: $value, children: $children}';
  }
}

class OperationNode {
  Operation operation;

  List<NumberNode> children;

  OperationNode(this.operation, this.children);

  @override
  String toString() {
    return 'OperationNode{operation: $operation, children: $children}';
  }
}

NumberNode parseTree(List<int> numbers, List<Operation> allowedOperations) {
  final reversedNumbers = numbers.reversed;
  NumberNode currentNode = NumberNode(reversedNumbers.first);

  for (var number in reversedNumbers.skip(1)) {
    final operationNodes = allowedOperations
        .map((operation) => OperationNode(operation, [currentNode]))
        .toList();

    currentNode = NumberNode.withChildren(number, operationNodes);
  }

  return currentNode;
}

(int, NumberNode) parseInput(String input, List<Operation> allowedOperations) {
  final [rawResultString, rawNumbersString] = input.split(": ");
  final parsedResult = int.parse(rawResultString);
  final parsedNumbers = rawNumbersString
      .split(" ")
      .where((entry) => entry.isNotEmpty)
      .map(int.parse)
      .toList();

  final numbersTree = parseTree(parsedNumbers, allowedOperations);

  return (parsedResult, numbersTree);
}

int applyOperation(Operation operation, int lhs, int rhs) {
  switch (operation) {
    case Operation.add:
      return lhs + rhs;
    case Operation.multiply:
      return lhs * rhs;
    case Operation.concat:
      return int.parse("$lhs$rhs");
  }
}

bool validateLine((int, NumberNode) line) {
  final expectedResult = line.$1;
  final rootNode = line.$2;

  return rootNode.children.any(
    (operationNode) => calculateResult(
      expectedResult,
      rootNode.value,
      operationNode,
    ),
  );
}

bool calculateResult(
  int expectedResult,
  int intermediateResult,
  OperationNode operationNode,
) {
  return operationNode.children.any((numberNode) {
    final newIntermediateResult = applyOperation(
      operationNode.operation,
      intermediateResult,
      numberNode.value,
    );

    if (numberNode.children.isEmpty) {
      return newIntermediateResult == expectedResult;
    }

    return numberNode.children.any((childOperationNode) => calculateResult(
          expectedResult,
          newIntermediateResult,
          childOperationNode,
        ));
  });
}

void part1() {
  final fileContents = readInputFile(2024, 7, "input");
  final parsedInput = fileContents.split("\n").map((line) => parseInput(line, [
        Operation.add,
        Operation.multiply,
      ]));
  final validLines = parsedInput.where(validateLine).toList();
  final result = validLines.fold(0, (acc, line) => acc + line.$1);

  print("Result: $result");
}

void part2() {
  final fileContents = readInputFile(2024, 7, "input");
  final parsedInput = fileContents.split("\n").map((line) => parseInput(line, [
        Operation.add,
        Operation.multiply,
        Operation.concat,
      ]));
  final validLines = parsedInput.where(validateLine).toList();
  final result = validLines.fold(0, (acc, line) => acc + line.$1);

  print("Result: $result");
}
