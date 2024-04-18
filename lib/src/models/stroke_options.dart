import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/enums/stroke_type.dart';

class StrokeOptions {
  /// The base size (diameter) of the stroke.
  /// Range: [0,100]
  double size;

  /// The effect of pressure on the stroke's size.
  /// Range: [-1,1]
  double thinning;

  /// Controls the density of points along the stroke's edges.
  /// Range: [0,1]
  double smoothing;

  /// Controls the level of variation allowed in the input points.
  /// Range: [0,1]
  double streamline;

  // Whether to simulate pressure or use the point's provided pressures.
  final bool simulatePressure;

  // The distance to taper the front of the stroke.
  // Range: [0,100]
  double taperStart;

  // The distance to taper the end of the stroke.
  // Range: [0,100]
  double taperEnd;

  // Whether to add a cap to the start of the stroke.
  final bool capStart;

  // Whether to add a cap to the end of the stroke.
  final bool capEnd;

  // Whether the line is complete.
  final bool isComplete;

  //color of line
  Color color;

  StrokeType strokeType;

  StrokeOptions(
      {this.size = 3,
        this.thinning = 0.2,
        this.smoothing = 0.5,
        this.streamline = 0.5,
        this.taperStart = 0.0,
        this.capStart = true,
        this.taperEnd = 0.0,
        this.capEnd = true,
        this.simulatePressure = true,
        this.isComplete = false,
        this.color = Colors.white,
        this.strokeType = StrokeType.pen
      });
}