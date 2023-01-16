import 'package:geo_utils/bounds.dart';
import 'package:geo_utils/polygon.dart';
import 'package:geo_utils/polygon_bounds_extension.dart';
import 'package:geo_utils/segment.dart';
import 'package:geo_utils/segment_is_crossing_extension.dart';
import 'package:vector_math/vector_math.dart';

extension VectorIsInsidePolygonExtension on Vector2 {
  bool isInsidePolygonEvenOdd(Polygon polygon) {
    final bounds = polygon.getBounds();
    if (!isInsideBounds(bounds)) return false;
    Segment lineToRight = Segment(this, Vector2(bounds.maxX, y));
    List<Segment> crossingSegments = _crossingSegments(lineToRight, polygon);
    int collisions = crossingSegments.length;
    return collisions % 2 == 1;
  }

  bool isInsidePolygonWindingNumber(Polygon polygon) {
    final bounds = polygon.getBounds();
    if (!isInsideBounds(bounds)) return false;
    Segment lineSegment = Segment(this, Vector2(bounds.maxX, y));
    Vector2 lineVector = lineSegment.end - lineSegment.start;
    Vector2 lineNormal = Vector2(-lineVector.y, lineVector.x);
    List<Segment> crossingSegments = _crossingSegments(lineSegment, polygon);
    int windingNumber = 0;
    for (Segment otherSegment in crossingSegments) {
      Vector2 otherVector = otherSegment.end - otherSegment.start;
      double dotProduct = lineNormal.dot(otherVector);
      if (dotProduct > 0) {
        windingNumber += 1;
      } else if (dotProduct < 0) {
        windingNumber -= 1;
      }
    }
    return windingNumber != 0;
  }

  List<Segment> _crossingSegments(Segment segment, Polygon polygon) {
    List<Segment> crossingSegments = [];
    for (Segment segmentInPolygon in polygon.segments) {
      if (segment.isCrossing(segmentInPolygon)) {
        crossingSegments.add(segmentInPolygon);
      }
    }
    return crossingSegments;
  }

  bool isInsideBounds(Bounds bounds) {
    return x >= bounds.minX &&
        x <= bounds.maxX &&
        y >= bounds.minY &&
        y <= bounds.maxY;
  }
}
