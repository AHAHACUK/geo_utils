import 'package:geo_utils/segment.dart';
import 'package:vector_math/vector_math.dart';

extension SegmentIsCrossingExtension on Segment {
  // https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
  // p + t r = q + u s
  // t = (q − p) × s / (r × s)
  // u = (q − p) × r / (r × s)
  bool isCrossing(Segment other) {
    Vector2 p = start;
    Vector2 q = other.start;
    Vector2 qp = q - p;
    final r = end - start;
    final s = other.end - other.start;
    final rs = r.cross(s);
    final qps = (qp).cross(s);
    if (rs == 0 && qps == 0) {
      // Линии коллинеарны и лежат на одной прямой.
      // Надо выразить точки other.start и other.end выражением первой линии:
      // 1. p + t0 r = q
      //    t0 = (q - p) / r
      // 2. p + t1 r = p + t0 r + s
      //    t1 r = t0 r + s
      //    t1 = t0 + s / r
      final t0 = start.x != other.start.x ? (q - p).x / r.x : (q - p).y / r.y;
      final t1 = end.x != other.end.x ? t0 + s.x / r.x : t0 + s.y / r.y;
      // Начальная точка второго отрезка лежит на первом отрезке
      if (t0 >= 0 && t0 <= 1) return true;
      // Конечная точка второго отрезка лежит на первом отрезке
      if (t1 >= 0 && t1 <= 1) return true;
      // Первый отрезок лежит внутри второго отрезка
      if (t0 < 0 && t1 > 1 || t1 < 0 && t0 > 1) return true;
      // Иначе, отрезки не пересекаются
      return false;
    }
    else if (rs == 0) {
      // Линни коллинеарны и не лежат на одной прямой
      // Точно не пересекаются
      return false;
    }
    else {
      // Линии неколлинеарны, и их прямые точно пересекаются
      // Нужно проверить происходит ли пересечение на указанных отрезках
      final t = qps / rs;
      final qpr = (qp).cross(r);
      final u = qpr / rs;
      if (t >= 0 && t <= 1 && u >= 0 && u <= 1) {
        return true;
      }
      else {
        return false;
      }
    }
  }
}
