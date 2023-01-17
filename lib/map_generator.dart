import 'package:geo_utils/polygon.dart';
import 'package:geo_utils/polygon_generator.dart';
import 'package:geo_utils/map.dart';

class MapGenerator {

  final polygonGenerator;

  MapGenerator(this.polygonGenerator);
  
  Map Next(int polygonCount, int segmentsCount) {
    List<Polygon> polygons = [];
    for (int i = 0; i < polygonCount; i++) {
      polygons.add(polygonGenerator.next(segmentsCount));
    }
    return Map(polygons);
  }
}