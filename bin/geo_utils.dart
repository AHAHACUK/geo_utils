import 'package:geo_utils/console_utils.dart';
import 'package:geo_utils/map_find_polygon_even_odd_test.dart';
import 'package:geo_utils/vector_is_inside_polygon.dart';

void main(List<String> arguments) {
  final tests = MapFindPolygonMethodTest(
    (point, polygon) => point.isInsidePolygonEvenOdd(polygon),
  );
  tests.polygonCounts = [10, 100, 1000, 6000, 10000];
  tests.segmentCounts = [10, 100, 1000, 6000];
  tests.process();
  ConsoleUtils.printTable(
    table: tests.result,
    columnLabels: tests.segmentCounts.map((e) => e.toString()).toList(),
    rowLabels: tests.polygonCounts.map((e) => e.toString()).toList(),
    rowsHeader: "polygons=",
    columnsHeader: "segments=",
    columnWidth: 16,
    dataPostfix: " ms",
  );
}
