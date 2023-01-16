import 'dart:io';

class ConsoleUtils {
  static void printTable({
    required List<List<int>> table,
    required List<String> columnLabels,
    required List<String> rowLabels,
    required String rowsHeader,
    required String columnsHeader,
    required int columnWidth,
    required String dataPostfix,
  }) {
    stdout.write("\n");
    stdout.write("".padRight(columnWidth));
    for (int i = 0; i < columnLabels.length; i++) {
      stdout.write("$columnsHeader${columnLabels[i]}".padRight(columnWidth));
    }
    stdout.write("\n");
    for (int i = 0; i < table.length; i++) {
      final row = table[i];
      stdout.write("$rowsHeader${rowLabels[i]}".padRight(columnWidth));
      for (int j = 0; j < row.length; j++) {
        stdout.write("${table[i][j]}$dataPostfix".padRight(columnWidth));
      }
      stdout.write("\n");
    }
    stdout.write("\n");
  }
}
