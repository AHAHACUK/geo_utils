import 'package:geo_utils/bounds.dart';
import 'package:geo_utils/polygon.dart';
import 'package:geo_utils/polygon_bounds_extension.dart';
import 'package:geo_utils/segment_is_crossing_extension.dart';
import 'package:geo_utils/segment.dart';
import 'package:geo_utils/vector_is_inside_polygon.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  group("isCrossing", () {
    test('dont cross when non-collinear', () {
      final seg1 = Segment(Vector2(1, 2), Vector2(3, 4));
      final seg2 = Segment(Vector2(4, 0), Vector2(3, 6));
      expect(seg1.isCrossing(seg2), false);
    });

    test('cross when non-collinear', () {
      final seg1 = Segment(Vector2(1, 2), Vector2(3, 4));
      final seg2 = Segment(Vector2(2, 0), Vector2(3, 6));
      expect(seg1.isCrossing(seg2), true);
    });

    test('dont cross when collinear and not on same line', () {
      final seg1 = Segment(Vector2(1, 2), Vector2(3, 4));
      final seg2 = Segment(Vector2(1, 1), Vector2(2, 2));
      expect(seg1.isCrossing(seg2), false);
    });

    test('dont cross when collinear and on same line', () {
      final seg1 = Segment(Vector2(1, 2), Vector2(3, 4));
      final seg2 = Segment(Vector2(4, 5), Vector2(6, 7));
      expect(seg1.isCrossing(seg2), false);
    });

    test('cross when collinear and on same line', () {
      final seg1 = Segment(Vector2(1, 2), Vector2(3, 4));
      final seg2 = Segment(Vector2(2, 3), Vector2(6, 7));
      expect(seg1.isCrossing(seg2), true);
    });

    test('cross when first segment is part of second segment', () {
      final seg1 = Segment(Vector2(1, 2), Vector2(6, 7));
      final seg2 = Segment(Vector2(2, 3), Vector2(5, 6));
      expect(seg1.isCrossing(seg2), true);
    });
  });

  group("getBounds", () {
    final polygon = Polygon([
      Segment(Vector2(1, 1), Vector2(2, 3)),
      Segment(Vector2(2, 3), Vector2(4, 4)),
      Segment(Vector2(4, 4), Vector2(4, 2)),
      Segment(Vector2(4, 2), Vector2(5, 3)),
      Segment(Vector2(5, 3), Vector2(5, 0)),
      Segment(Vector2(5, 0), Vector2(2, -1)),
      Segment(Vector2(2, -1), Vector2(1, 1)),
    ]);
    test('bounds', () {
      Bounds bounds = polygon.getBounds();
      expect(bounds.minX, 1);
      expect(bounds.maxX, 5);
      expect(bounds.minY, -1);
      expect(bounds.maxY, 4);
    });
  });

  group("isInside", () {
    final polygon = Polygon([
      Segment(Vector2(1, 1), Vector2(2, 3)),
      Segment(Vector2(2, 3), Vector2(4, 4)),
      Segment(Vector2(4, 4), Vector2(4, 2)),
      Segment(Vector2(4, 2), Vector2(5, 3)),
      Segment(Vector2(5, 3), Vector2(5, 0)),
      Segment(Vector2(5, 0), Vector2(2, -1)),
      Segment(Vector2(2, -1), Vector2(1, 1)),
    ]);
    test('point in center', () {
      final point = Vector2(3, 1);
      expect(point.isInside(polygon), true);
    });
    test('point completly outside', () {
      final point = Vector2(0, 5);
      expect(point.isInside(polygon), false);
    });
    test('point outside, but on one horizontal line in center', () {
      final point = Vector2(0, 1);
      expect(point.isInside(polygon), false);
    });

    test('point outside, but on one horizontal line with concave edge', () {
      final point = Vector2(0, 2.5);
      expect(point.isInside(polygon), false);
    });

    test('point outside, but on one horizontal line with vertex', () {
      final point = Vector2(0, -1);
      expect(point.isInside(polygon), false);
    });

    test('point on vertex', () {
      final point = Vector2(2, 3);
      expect(point.isInside(polygon), true);
    });

    test('point inside on one horizontal line with concave edge', () {
      final point = Vector2(3, 2.5);
      expect(point.isInside(polygon), true);
    });
  });
}
