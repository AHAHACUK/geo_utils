import 'dart:math';

import 'package:geo_utils/polygon.dart';
import 'package:geo_utils/segment.dart';
import 'package:vector_math/vector_math.dart';

class PolygonGenerator {
  final double maxOffset;
  final double maxRadius;

  PolygonGenerator(this.maxOffset, this.maxRadius);

  Polygon next(int segmentsCount) {
    List<Segment> segments = [];
    for (int i = 0; i < segmentsCount; i++) {
      Vector2 startPont = Vector2(0, 1);
      Vector2 endPoint = Vector2(0, -1);
      Segment segment = Segment(startPont, endPoint);
      segments.add(segment);
    }
    return Polygon(segments);
  }
}
