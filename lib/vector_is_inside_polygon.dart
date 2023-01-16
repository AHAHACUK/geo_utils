import 'package:geo_utils/polygon.dart';
import 'package:geo_utils/polygon_bounds_extension.dart';
import 'package:geo_utils/segment.dart';
import 'package:geo_utils/segment_is_crossing_extension.dart';
import 'package:vector_math/vector_math.dart';

extension VectorIsInsidePolygonExtension on Vector2 {
  bool isInside(Polygon polygon) {
    final bounds = polygon.getBounds();
    if (x < bounds.minX ||
        x > bounds.maxX ||
        y < bounds.minY ||
        y > bounds.maxY) {
      return false;
    }
    Segment lineToRight = Segment(this, Vector2(bounds.maxX, y));
    int collisions =_countCollisions(lineToRight, polygon);
    return collisions % 2 == 1;
  }

  int _countCollisions(Segment segment, Polygon polygon) {
    int count = 0;
    for(Segment segmentInPolygon in polygon.segments) {
      if (segment.isCrossing(segmentInPolygon)) {
        count += 1;
      }
    }
    return count;
  }
}
