import 'package:geo_utils/polygon.dart';

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