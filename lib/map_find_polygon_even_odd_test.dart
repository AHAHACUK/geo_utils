import 'package:geo_utils/map_generator.dart';
import 'package:geo_utils/map_test.dart';
import 'package:geo_utils/polygon.dart';
import 'package:geo_utils/polygon_generator.dart';
import 'package:geo_utils/time_test.dart';
import 'package:vector_math/vector_math.dart';
import 'map.dart';

class MapFindPolygonMethodTest extends MapTest {
  bool Function(Vector2, Polygon) isInsideMethod;

  MapFindPolygonMethodTest(this.isInsideMethod);

  @override
  void process() {
    final double maxOffset = 10000;
    final double maxRadius = 100;
    final Vector2 testPoint = Vector2(maxOffset + maxRadius + 1, 0);
    final polygonGenerator = PolygonGenerator(maxOffset, maxRadius);
    final mapGenerator = MapGenerator(polygonGenerator);
    final tests = List.generate(
      polygonCounts.length,
      growable: false,
      (index) => List.filled(
        segmentCounts.length,
        -1,
      ),
    );
    for (int i = 0; i < polygonCounts.length; i++) {
      for (int j = 0; j < segmentCounts.length; j++) {
        final map = mapGenerator.Next(polygonCounts[i], segmentCounts[j]);
        tests[i][j] = TimeTest.test(() {
          map.findPolygon((polygon) => isInsideMethod(testPoint, polygon));
        });
      }
    }
    result = tests;
  }
}
