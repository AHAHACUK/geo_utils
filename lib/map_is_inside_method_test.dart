import 'package:geo_utils/polygon.dart';
import 'package:vector_math/vector_math.dart';

class MapIsInsidenMethodTest {
  final String name;
  final bool Function(Vector2, Polygon) isInsideMethod;

  MapIsInsidenMethodTest(this.name, this.isInsideMethod);
}
