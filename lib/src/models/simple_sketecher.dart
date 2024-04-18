import 'package:flutter/material.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

import 'stroke.dart';



/// A custom painter class that draws a list of strokes on a canvas.
///
/// Uses the `perfect_freehand` package to generate stroke outlines for natural hand-drawn effects.
/// This painter is designed to be used in scenarios where dynamic, free-form drawing is needed.
///
/// [lines] - List of `Stroke` objects containing the details of each line to be drawn, including points, color, and stroke options.
class SimpleSketcher extends CustomPainter {
  final List<Stroke> lines;

  /// Constructs a `SimpleSketcher` that will paint the provided [lines].
  SimpleSketcher(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeJoin = StrokeJoin.round // Ensures that stroke joins are rounded.
      ..strokeCap = StrokeCap.round // Ends of lines are rounded.
      ..strokeMiterLimit = 5 // The limit for the miter when strokes join.
      ..filterQuality = FilterQuality.high // Higher quality filter settings for better anti-aliasing.
      ..style = PaintingStyle.fill; // The paint will be used to fill the drawing.

    for (Stroke line in lines) {
      final options = line.options;
      final outlinePoints = getStroke(
        line.points,
        options: StrokeOptions(
          size: options.size, // The thickness of the stroke.
          thinning: options.thinning, // The degree to which the stroke thickness is reduced based on velocity.
          smoothing: options.smoothing, // How much the input points are smoothed before drawing.
          streamline: options.streamline, // How much the input points are corrected to form a smoother line.
          start: options.start, // Start tapering length.
          end: options.end, // End tapering length.
          simulatePressure: options.simulatePressure, // Simulates pressure sensitivity.
          isComplete: options.isComplete, // Indicates if the stroke is complete.
        ),
      );

      paint.color = line.color; // Set the color of the stroke.

      final path = Path();
      if (outlinePoints.isEmpty) return;
      if (outlinePoints.length < 2) {
        // Draws a circle for a single point to ensure it's visible.
        path.addOval(Rect.fromCircle(center: Offset(outlinePoints[0].dx, outlinePoints[0].dy), radius: 1));
      } else {
        // Draws the stroke as a series of quadratic bezier curves.
        path.moveTo(outlinePoints[0].dx, outlinePoints[0].dy);
        for (int i = 1; i < outlinePoints.length - 1; i++) {
          final p0 = outlinePoints[i];
          final p1 = outlinePoints[i + 1];
          path.quadraticBezierTo(p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(SimpleSketcher oldDelegate) {
    // Indicates whether the painter should repaint.
    return oldDelegate.lines != lines;
  }
}



