import "dart:io";

String readInputFile(int year, int day, String fileName) {
  final formattedDay = day.toString().padLeft(2, "0");

  return File(
    "./inputs/$year/day$formattedDay/$fileName.txt",
  ).readAsStringSync();
}
