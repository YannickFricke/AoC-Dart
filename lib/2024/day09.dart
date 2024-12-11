import 'package:advent_of_code/utils.dart';

const freeSpaceFileId = -1;

typedef FileEntry = ({int id, int amount});

bool isFreeSpaceEntry(FileEntry fileEntry) => fileEntry.id == freeSpaceFileId;

List<FileEntry> parseFileEntries(String line) {
  return line
      .split("")
      .where((number) => number.isNotEmpty)
      .map(int.parse)
      .indexed
      .fold((<FileEntry>[], 0), (acc, entry) {
    final index = entry.$1;
    final parsedNumber = entry.$2;

    if (index % 2 == 0) {
      return ([...acc.$1, (id: acc.$2, amount: parsedNumber)], acc.$2 + 1);
    }

    return ([...acc.$1, (id: freeSpaceFileId, amount: parsedNumber)], acc.$2);
  }).$1;
}

List<FileEntry> defragBySectors(List<FileEntry> fileEntries) {
  final result = [...fileEntries];

  var currentIndex = 0;
  var fileIndex = result.length - 1;

  while (true) {
    var freeSpaceEntry = result[currentIndex];

    while (isFreeSpaceEntry(freeSpaceEntry) == false) {
      currentIndex++;
      freeSpaceEntry = result[currentIndex];
    }

    var fileEntry = result[fileIndex];

    while (isFreeSpaceEntry(fileEntry)) {
      fileIndex--;
      fileEntry = result[fileIndex];
    }

    if (currentIndex > fileIndex) {
      break;
    }

    if (freeSpaceEntry.amount == fileEntry.amount) {
      // Both entries have the same amount

      result[currentIndex] = fileEntry;
      result[fileIndex] = freeSpaceEntry;
    } else if (freeSpaceEntry.amount > fileEntry.amount) {
      // We have more free space than amount of files to move

      result[currentIndex] = (
        id: freeSpaceFileId,
        amount: freeSpaceEntry.amount - fileEntry.amount
      );
      result[fileIndex] = (id: freeSpaceFileId, amount: fileEntry.amount);
      result.insert(currentIndex, fileEntry);
    } else {
      // We have more files to move than amount of free space

      result[currentIndex] = (id: fileEntry.id, amount: freeSpaceEntry.amount);
      result[fileIndex] = (
        id: fileEntry.id,
        amount: fileEntry.amount - freeSpaceEntry.amount,
      );
      result.insert(fileIndex + 1, freeSpaceEntry);
    }
  }

  return result;
}

List<int> expandFileEntries(List<FileEntry> fileEntries) {
  return fileEntries
      .expand((entry) => List.filled(entry.amount, entry.id))
      .toList();
}

void debugFileEntries(List<FileEntry> entries, {bool printSeparator = false}) {
  final stringToWrite = expandFileEntries(entries).map((entry) {
    if (entry == freeSpaceFileId) {
      return ".";
    }

    return entry.toString();
  }).join("");

  if (printSeparator) {
    print("-" * stringToWrite.length);
  }

  print(stringToWrite);
}

List<FileEntry> defragByBlocks(List<FileEntry> fileEntries) {
  final result = [...fileEntries].reversed.toList();

  for (var currentIndex = 0; currentIndex < result.length; currentIndex++) {
    final currentEntry = result[currentIndex];

    if (isFreeSpaceEntry(currentEntry)) {
      continue;
    }

    final freeSpaceElementIndex =
        result.reversed.toList(growable: false).indexWhere(
              (element) =>
                  isFreeSpaceEntry(element) &&
                  element.amount >= currentEntry.amount,
            );

    if (freeSpaceElementIndex == -1) {
      continue;
    }

    final resolvedFreeSpaceElementIndex =
        result.length - 1 - freeSpaceElementIndex;

    if (currentIndex > resolvedFreeSpaceElementIndex) {
      continue;
    }

    final freeSpaceEntry = result[resolvedFreeSpaceElementIndex];

    if (currentEntry.amount == freeSpaceEntry.amount) {
      result[currentIndex] = freeSpaceEntry;
      result[resolvedFreeSpaceElementIndex] = currentEntry;
    } else {
      // We have more free space than amount of files to move
      result[currentIndex] = (
        id: freeSpaceFileId,
        amount: currentEntry.amount,
      );
      result[resolvedFreeSpaceElementIndex] = (
        id: freeSpaceFileId,
        amount: freeSpaceEntry.amount - currentEntry.amount,
      );
      result.insert(resolvedFreeSpaceElementIndex + 1, currentEntry);
    }
  }

  return result.reversed.toList();
}

int calculateChecksum(List<int> fileEntries) {
  var result = 0;

  for (var i = 0; i < fileEntries.length; i++) {
    final currentEntry = fileEntries[i];

    if (currentEntry == freeSpaceFileId) {
      continue;
    }

    result += i * currentEntry;
  }

  return result;
}

void part1() {
  final parsedLines = readInputFile(2024, 9, "input")
      .split("\n")
      .map(parseFileEntries)
      .map(defragBySectors)
      .map(expandFileEntries)
      .map(calculateChecksum);

  print(parsedLines);
}

void part2() {
  final parsedLines = readInputFile(2024, 9, "input")
      .split("\n")
      .map(parseFileEntries)
      .map(defragByBlocks)
      .map(expandFileEntries)
      .map(calculateChecksum);

  print(parsedLines);
}
