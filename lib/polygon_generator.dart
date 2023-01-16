import 'dart:math';

import 'package:geo_utils/polygon.dart';
import 'package:geo_utils/segment.dart';
import 'package:vector_math/vector_math.dart';

class PolygonGenerator {
  final double maxOffset;
  final double maxRadius;
  final Random _random = Random();

  PolygonGenerator(this.maxOffset, this.maxRadius);

  Polygon Next(int segmentsCount) {
    double centerX = _random.nextDouble() * maxOffset * 2 - maxOffset;
    double centerY = _random.nextDouble() * maxOffset * 2 - maxOffset;
    Vector2 center = Vector2(centerX, centerY);
    List<Segment> segments = [];
    for (int i = 0; i < segmentsCount; i++) {
      double localStartX = _random.nextDouble() * maxRadius;
      double localStartY = _random.nextDouble() * maxRadius;
      Vector2 localStart = Vector2(localStartX, localStartY);
      Vector2 globalStart = localStart + center;

      double localEndX = _random.nextDouble() * maxRadius;
      double localEndY = _random.nextDouble() * maxRadius;
      Vector2 localEnd = Vector2(localEndX, localEndY);
      Vector2 globalEnd= localEnd + center;
      Segment segment = Segment(globalStart, globalEnd);
      segments.add(segment);
    }
    return Polygon(segments);
  }
}
