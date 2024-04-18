import 'package:flutter/material.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

import 'stroke.dart';



class SimpleSketcher extends CustomPainter {
  final List<Stroke> lines;

  SimpleSketcher(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..strokeMiterLimit = 5
      ..filterQuality = FilterQuality.high
      ..style = PaintingStyle.fill;

    for (int i = 0; i < lines.length; ++i) {
      final outlinePoints = getStroke(
        lines[i].points,
        options: StrokeOptions(
          size: lines[i].options.size,
          thinning: lines[i].options.thinning,
          smoothing: lines[i].options.smoothing,
          streamline: lines[i].options.streamline,
          start: lines[i].options.start,
          end: lines[i].options.end,
          simulatePressure: lines[i].options.simulatePressure,
          isComplete: lines[i].options.isComplete,
        ),

      );

      paint.color = lines[i].color;

      final path = Path();
      if (outlinePoints.isEmpty) {
        return;
      } else if (outlinePoints.length < 2) {
        path.addOval(Rect.fromCircle(
            center: Offset(outlinePoints[0].dx, outlinePoints[0].dy), radius: 1));
      } else {
        path.moveTo(outlinePoints[0].dx, outlinePoints[0].dy);
        for (int i = 1; i < outlinePoints.length - 1; ++i) {
          final p0 = outlinePoints[i];
          final p1 = outlinePoints[i + 1];
          path.quadraticBezierTo(
              p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(SimpleSketcher oldDelegate) {
    return oldDelegate.lines != lines;
  }
}



