import 'package:geo_utils/polygon.dart';
import 'package:geo_utils/segment.dart';

import 'bounds.dart';

extension PolygonBoudndsExtension on Polygon {
  Bounds getBounds() {
    double minX = double.maxFinite;
    double maxX = -double.maxFinite;
    double minY = double.maxFinite;
    double maxY = -double.maxFinite;
    for (Segment segment in segments) {
      if (segment.start.x < minX) minX = segment.start.x;
      if (segment.start.x > maxX) maxX = segment.start.x;
      if (segment.end.x < minX) minX = segment.end.x;
      if (segment.end.x > maxX) maxX = segment.end.x;
      if (segment.start.y < minY) minY = segment.start.y;
      if (segment.start.y > maxY) maxY = segment.start.y;
      if (segment.end.y < minY) minY = segment.end.y;
      if (segment.end.y > maxY) maxY = segment.end.y;
    }
    return Bounds(minX, maxX, minY, maxY);
  }
}
