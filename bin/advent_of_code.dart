import 'package:advent_of_code/2023/day04.dart' as y2023d4;
import 'package:advent_of_code/2024/day03.dart' as y2024d3;
import 'package:advent_of_code/2024/day04.dart' as y2024d4;
import 'package:advent_of_code/2024/day05.dart' as y2024d5;
import 'package:advent_of_code/2024/day06.dart' as y2024d6;
import 'package:advent_of_code/2024/day07.dart' as y2024d7;
import 'package:advent_of_code/2024/day08.dart' as y2024d8;
import 'package:advent_of_code/2024/day09.dart' as y2024d9;
import 'package:advent_of_code/2024/day10.dart' as y2024d10;
import 'package:advent_of_code/2024/day11.dart' as y2024d11;
import 'package:advent_of_code/2024/day12.dart' as y2024d12;

void main(List<String> arguments) {
  final year = 2024;
  final day = 12;
  final part = 2;

  final stopWatch = Stopwatch();
  stopWatch.start();

  switch ((year, day, part)) {
    case (2023, 4, 1):
      y2023d4.part1();
      break;

    case (2023, 4, 2):
      y2023d4.part2();
      break;

    case (2024, 3, 1):
      y2024d3.part1();
      break;

    case (2024, 3, 2):
      y2024d3.part2();
      break;

    case (2024, 4, 1):
      y2024d4.part1();
      break;

    case (2024, 4, 2):
      y2024d4.part2();
      break;

    case (2024, 5, 1):
      y2024d5.part1();
      break;

    case (2024, 5, 2):
      y2024d5.part2();

    case (2024, 6, 1):
      y2024d6.part1();
      break;

    case (2024, 6, 2):
      y2024d6.part2();

    case (2024, 7, 1):
      y2024d7.part1();
      break;

    case (2024, 7, 2):
      y2024d7.part2();
      break;

    case (2024, 8, 1):
      y2024d8.part1();
      break;

    case (2024, 8, 2):
      y2024d8.part2();
      break;

    case (2024, 9, 1):
      y2024d9.part1();
      break;

    case (2024, 9, 2):
      y2024d9.part2();
      break;

    case (2024, 10, 1):
      y2024d10.part1();
      break;

    case (2024, 10, 2):
      y2024d10.part2();
      break;

    case (2024, 11, 1):
      y2024d11.part1();
      break;

    case (2024, 11, 2):
      y2024d11.part2();
      break;

    case (2024, 12, 1):
      y2024d12.part1();
      break;

    case (2024, 12, 2):
      y2024d12.part2();
      break;

    default:
      print("Could not find year $year, day $day and part $part");
      break;
  }

  stopWatch.stop();

  print("Execution took ${stopWatch.elapsedMilliseconds}ms");
}
