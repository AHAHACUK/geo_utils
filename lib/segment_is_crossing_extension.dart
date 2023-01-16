import 'package:geo_utils/segment.dart';
import 'package:vector_math/vector_math.dart';

extension SegmentIsCrossingExtension on Segment {
  static const double MAX_ERROR = 0.001;
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
    // TODO Обдумать ещё раз. Стоит ли рассматривать коллириарные линии.
    // if (rs == 0 && qps == 0) {
    //   // Линии коллинеарны и лежат на одной прямой.
    //   // Надо выразить точки other.start и other.end выражением первой линии:
    //   // 1. p + t0 r = q
    //   //    t0 = (q - p) / r
    //   // 2. p + t1 r = p + t0 r + s
    //   //    t1 r = t0 r + s
    //   //    t1 = t0 + s / r
    //   final t0 = start.x != other.start.x ? (q - p).x / r.x : (q - p).y / r.y;
    //   final t1 = end.x != other.end.x ? t0 + s.x / r.x : t0 + s.y / r.y;
    //   // Начальная точка второго отрезка лежит на первом отрезке
    //   if (t0 >= 0 && t0 <= 1) return true;
    //   // Конечная точка второго отрезка лежит на первом отрезке
    //   if (t1 >= 0 && t1 <= 1) return true;
    //   // Первый отрезок лежит внутри второго отрезка
    //   if (t0 < 0 && t1 > 1 || t1 < 0 && t0 > 1) return true;
    //   // Иначе, отрезки не пересекаются
    //   return false;
    // }
    if (rs == 0) {
      // Линни коллинеарны.
      // Даже если у них есть общии точки, пересечения не происходит.
      return false;
    } else {
      // Линии неколлинеарны, и их прямые точно пересекаются
      // Нужно проверить происходит ли пересечение на указанных отрезках
      final t = qps / rs;
      final qpr = (qp).cross(r);
      final u = qpr / rs;
      // Если какой-то из отрезков не на [0;1], то линии не пересекаются
      if (t < 0 || t > 1 || u < 0 || u > 1) return false;
      // Проверка на то, что пересечение происходит на вершине
      // Значение MAX_ERROR добавляется из-за погрешности в вычислении double
      if (u <= MAX_ERROR ||
          u >= 1 - MAX_ERROR) {
        // Мы сдвигаем отрезок вверх относительно его направления
        // Полученный отрезок проверяем на пересечение с нужным
        return moveAlongNormal(MAX_ERROR).isCrossing(other);
      }
      return true;
    }
  }

  Segment moveAlongNormal(double offset) {
    Vector2 vector = end - start;
    Vector2 normal = Vector2(-vector.y, vector.x);
    return Segment(start + normal * offset, end + normal * offset);
  }
}
