import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/controller/controller.dart';
import 'package:flutter_story_editor/src/models/simple_sketecher.dart';
import 'package:flutter_story_editor/src/models/stroke.dart';
import 'package:flutter_story_editor/src/widgets/hue_color_picker_slider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

import 'paint_top_view.dart';

// PaintControlsView provides a customizable painting interface over an image or video.
class PaintControlsView extends StatefulWidget {
  final File selectedFile; // The file (image/video) being edited.
  final List<Stroke> uiEditableFileLines; // List of strokes drawn on the canvas.
  final VoidCallback onUndoClickListener; // Callback when the undo button is pressed.
  final Function(Stroke) onPointerDownUpdate; // Callback when a new stroke is started.
  final FlutterStoryEditorController controller; // Controller for managing editing state.
  final VoidCallback onDoneClickListener; // Callback when the done button is pressed.

  const PaintControlsView({
    super.key,
    required this.selectedFile,
    required this.controller,
    required this.uiEditableFileLines,
    required this.onPointerDownUpdate,
    required this.onUndoClickListener,
    required this.onDoneClickListener
  });

  @override
  PaintControlsViewState createState() => PaintControlsViewState();
}

class PaintControlsViewState extends State<PaintControlsView> {
  HSVColor _pencilColor = HSVColor.fromColor(Colors.tealAccent); // Initial pencil color.
  Stroke? line; // Current stroke being drawn.
  double size = 3; // Initial stroke size.

  // Handles pointer down event, initializing a new stroke.
  void onPointerDown(PointerDownEvent details) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);
    final point = details.kind == PointerDeviceKind.stylus
        ? PointVector(
      offset.dx,
      offset.dy / 2,
      (details.pressure - details.pressureMin) / (details.pressureMax - details.pressureMin),
    )
        : PointVector(offset.dx, offset.dy);
    final points = [point];
    line = Stroke(points, _pencilColor.toColor(), StrokeOptions(size: size));
    setState(() {
      widget.uiEditableFileLines.add(line!);
    });
  }

  // Updates the current stroke with new points as the pointer moves.
  void onPointerMove(PointerMoveEvent details) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);
    final point = details.kind == PointerDeviceKind.stylus
        ? PointVector(
      offset.dx,
      offset.dy,
      (details.pressure - details.pressureMin) / (details.pressureMax - details.pressureMin),
    )
        : PointVector(offset.dx, offset.dy);
    setState(() {
      line!.points.add(point);
    });
  }

  // Finalizes the stroke when the pointer is lifted.
  void onPointerUp(PointerUpEvent details) {
    widget.onPointerDownUpdate(line!);
    line = null;
  }

  @override
  Widget build(BuildContext context) {
    // Building the widget's visual structure.
    return Stack(
      alignment: Alignment.center,
      children: [
        // Listener to handle touch events on the canvas.
        Listener(
          onPointerDown: onPointerDown,
          onPointerUp: onPointerUp,
          onPointerMove: onPointerMove,
          child: CustomPaint(
            painter: SimpleSketcher(widget.uiEditableFileLines),
            child: Container(),
          ),
        ),
        // Top bar with painting controls.
        Align(
          alignment: Alignment.topCenter,
          child: PaintTopView(
            lines: widget.uiEditableFileLines,
            onDoneClickListener: () {
              widget.onDoneClickListener();
            },
            controller: widget.controller,
            onUndoClickListener: widget.onUndoClickListener,
            selectedFile: widget.selectedFile,
            pencilColor: _pencilColor,
          ),
        ),
        // Bottom bar with size controls.
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                bottomIcon(MdiIcons.sizeM, isSelected: size == 3, onTap: () {
                  setState(() {
                    size = 3;
                  });
                }),
                bottomIcon(MdiIcons.sizeL, isSelected: size == 6, onTap: () {
                  setState(() {
                    size = 6;
                  });
                }),
                bottomIcon(MdiIcons.sizeXl, isSelected: size == 9, onTap: () {
                  setState(() {
                    size = 9;
                  });
                }),
                bottomIcon(MdiIcons.sizeXxl, isSelected: size == 12, onTap: () {
                  setState(() {
                    size = 12;
                  });
                }),
              ],
            ),
          ),
        ),
        // Slider for changing the pencil color.
        Positioned(
          top: 100,
          right: 28,
          child: HueColorPickerSlider(
            onChanged: (hsvColor) {
              setState(() {
                _pencilColor = hsvColor;
              });
            },
          ),
        ),
      ],
    );
  }

  // Helper function to create icons for selecting stroke size.
  bottomIcon(IconData icon, {VoidCallback? onTap, bool? isSelected}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white.withOpacity(.2), border: isSelected == true ? Border.all(width: 1, color: Colors.white) : null),
        child: Icon(
          icon,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
