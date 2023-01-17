import 'package:geo_utils/console_utils.dart';
import 'package:geo_utils/map_generator.dart';
import 'package:geo_utils/map_is_inside_method_test.dart';
import 'package:geo_utils/polygon_generator.dart';
import 'package:geo_utils/time_test.dart';
import 'package:geo_utils/vector_is_inside_polygon.dart';
import 'package:vector_math/vector_math.dart';

void main(List<String> arguments) {
  final tests = [
    MapIsInsidenMethodTest(
      "TracingEvenOdd",
      (point, polygon) => point.isInsidePolygonEvenOdd(polygon),
    ),
    MapIsInsidenMethodTest(
      "TracingEvenOdd",
      (point, polygon) => point.isInsidePolygonEvenOdd(polygon),
    ),
    MapIsInsidenMethodTest(
      "TracingWindingNumber",
      (point, polygon) => point.isInsidePolygonWindingNumber(polygon),
    ),
    MapIsInsidenMethodTest(
      "AngleSum",
      (point, polygon) => point.isInsidePolygonAngleSum(polygon),
    ),
  ];
  final polygonCounts = [10, 100, 1000, 5000];
  final segmentCounts = [10, 100, 1000, 5000, 15000];

  final result = List.generate(
    tests.length,
    (index) => List.generate(
      polygonCounts.length,
      growable: false,
      (index) => List.filled(
        segmentCounts.length,
        -1,
      ),
    ),
  );

  final double maxOffset = 10000;
  final double maxRadius = 100;
  final Vector2 testPoint = Vector2(-2, 0);
  final polygonGenerator = PolygonGenerator(maxOffset, maxRadius);
  final mapGenerator = MapGenerator(polygonGenerator);
  for (int i = 0; i < polygonCounts.length; i++) {
    for (int j = 0; j < segmentCounts.length; j++) {
      final map = mapGenerator.Next(polygonCounts[i], segmentCounts[j]);
      for (int k = 0; k < tests.length; k++) {
        result[k][i][j] = TimeTest.test(
          () => map.findPolygon(
            (polygon) {
              tests[k].isInsideMethod(testPoint, polygon);
              return false;
            },
          ),
        );
      }
    }
  }

  for (int k = 0; k < tests.length; k++) {
    final test = tests[k];
    print(test.name);
    ConsoleUtils.printTable(
      table: result[k],
      columnLabels: segmentCounts.map((e) => e.toString()).toList(),
      rowLabels: polygonCounts.map((e) => e.toString()).toList(),
      rowsHeader: "polygons=",
      columnsHeader: "segments=",
      columnWidth: 16,
      dataPostfix: " ms",
    );
    print("");
  }
}
