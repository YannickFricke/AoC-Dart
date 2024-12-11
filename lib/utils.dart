import "dart:io";

String readFile(String filePath) {
  return File(filePath).readAsStringSync();
}

String readInputFile(int year, int day, String fileName) {
  final formattedDay = day.toString().padLeft(2, "0");

  return readFile("./inputs/$year/day$formattedDay/$fileName.txt");
}
