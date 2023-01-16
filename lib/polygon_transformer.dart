import 'package:geo_utils/segment.dart';
import 'package:vector_math/vector_math.dart';

import 'polygon.dart';

class PolygonTransformer {
  Polygon polygon;

  PolygonTransformer(this.polygon);

  void scale(double scale) {
    Vector2 center = _getCenter();
    List<Segment> scaledSegments = [];
    for (Segment segment in polygon.segments) {
      final localStart = segment.start - center;
      final scaledLocalStart = localStart * scale;
      final scaledStart = scaledLocalStart + center;

      final localEnd = segment.end - center;
      final scaledLocalEnd = localEnd * scale;
      final scaledEnd = scaledLocalEnd + center;
      scaledSegments.add(Segment(scaledStart, scaledEnd));
    }
    polygon = Polygon(scaledSegments);
  }

  Vector2 _getCenter() {
    Vector2 sum = Vector2.zero();
    for (Segment segment in polygon.segments) {
      sum += segment.start;
    }
    return sum / polygon.segments.length.toDouble();
  }
}
