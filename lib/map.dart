import 'package:geo_utils/polygon.dart';
import 'package:geo_utils/vector_is_inside_polygon.dart';
import 'package:vector_math/vector_math.dart';

class Map {
  final List<Polygon> polygons;

  Map(this.polygons);

  Polygon? findPolygon(bool Function(Polygon) condition) {
    for(Polygon polygon in polygons) {
      if (condition(polygon)) return polygon;
    }
    return null;
  }
}