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
      expect(seg1.isCrossing(seg2), false);
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
      Segment(Vector2(5, 0), Vector2(5, -4)),
      Segment(Vector2(5, -4), Vector2(8, -4)),
      Segment(Vector2(8, -4), Vector2(8, -3)),
      Segment(Vector2(8, -3), Vector2(-2, -3)),
      Segment(Vector2(-2, -3), Vector2(-2, -1)),
      Segment(Vector2(-2, -1), Vector2(10, -1)),
      Segment(Vector2(10, -1), Vector2(10, -6)),
      Segment(Vector2(10, -6), Vector2(6, -8)),
      Segment(Vector2(6, -8), Vector2(4, -6)),
      Segment(Vector2(4, -6), Vector2(4, 0)),
      Segment(Vector2(4, 0), Vector2(1, 1)),
    ]);
    group("isInsideEvenOdd", () {
      test('point in center', () {
        final point = Vector2(3, 1);
        expect(point.isInsidePolygonEvenOdd(polygon), true);
      });
      test('point completly outside', () {
        final point = Vector2(0, 5);
        expect(point.isInsidePolygonEvenOdd(polygon), false);
      });
      test('point outside, but on one horizontal line in center', () {
        final point = Vector2(0, 1.5);
        expect(point.isInsidePolygonEvenOdd(polygon), false);
      });

      test('point outside, but on one horizontal line with concave edge', () {
        final point = Vector2(0, 2.5);
        expect(point.isInsidePolygonEvenOdd(polygon), false);
      });

      test('point outside, but on one horizontal line with vertex in center',
          () {
        final point = Vector2(0, 1);
        expect(point.isInsidePolygonEvenOdd(polygon), false);
      });

      test('point outside, but on one horizontal line with vertex on edge', () {
        final point = Vector2(0, -8);
        expect(point.isInsidePolygonEvenOdd(polygon), false);
      });

      test('point inside on one horizontal line with concave edge', () {
        final point = Vector2(3, 2.5);
        expect(point.isInsidePolygonEvenOdd(polygon), true);
      });

      test('point inside crossing zone', () {
        final point = Vector2(4.5, -2);
        expect(point.isInsidePolygonEvenOdd(polygon), false);
      });
    });

    group("isInsideWindingNumber", () {
      test('point in center', () {
        final point = Vector2(3, 1);
        expect(point.isInsidePolygonWindingNumber(polygon), true);
      });
      test('point completly outside', () {
        final point = Vector2(0, 5);
        expect(point.isInsidePolygonWindingNumber(polygon), false);
      });
      test('point outside, but on one horizontal line in center', () {
        final point = Vector2(0, 1.5);
        expect(point.isInsidePolygonWindingNumber(polygon), false);
      });

      test('point outside, but on one horizontal line with concave edge', () {
        final point = Vector2(0, 2.5);
        expect(point.isInsidePolygonWindingNumber(polygon), false);
      });

      test('point outside, but on one horizontal line with vertex in center',
          () {
        final point = Vector2(0, 1);
        expect(point.isInsidePolygonWindingNumber(polygon), false);
      });

      test('point outside, but on one horizontal line with vertex on edge', () {
        final point = Vector2(0, -8);
        expect(point.isInsidePolygonWindingNumber(polygon), false);
      });

      test('point inside on one horizontal line with concave edge', () {
        final point = Vector2(3, 2.5);
        expect(point.isInsidePolygonWindingNumber(polygon), true);
      });

      test('point inside crossing zone', () {
        final point = Vector2(4.5, -2);
        expect(point.isInsidePolygonWindingNumber(polygon), true);
      });
    });
  });
}
