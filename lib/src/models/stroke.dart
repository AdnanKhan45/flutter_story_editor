
import 'package:flutter/material.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

class Stroke {
  final List<PointVector> points;
  final Color color;
  final StrokeOptions options;
  const Stroke(this.points, this.color, this.options);
}