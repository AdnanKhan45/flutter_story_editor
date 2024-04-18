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

class PaintControlsView extends StatefulWidget {
  final File selectedFile;
  final List<Stroke> uiEditableFileLines;
  final VoidCallback onUndoClickListener;
  final Function(Stroke) onPointerDownUpdate;
  final FlutterStoryEditorController controller;
  final VoidCallback onDoneClickListener;

  const PaintControlsView(
      {super.key,
      required this.selectedFile,
      required this.controller,
      required this.uiEditableFileLines,
      required this.onPointerDownUpdate,
      required this.onUndoClickListener,
      required this.onDoneClickListener});

  @override
  PaintControlsViewState createState() => PaintControlsViewState();
}

class PaintControlsViewState extends State<PaintControlsView> {
  HSVColor _pencilColor = HSVColor.fromColor(Colors.tealAccent);
  Stroke? line;

  double size = 3;

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

  void onPointerUp(PointerUpEvent details) {
    widget.onPointerDownUpdate(line!);
    line = null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Listener(
          onPointerDown: onPointerDown,
          onPointerUp: onPointerUp,
          onPointerMove: onPointerMove,
          child: CustomPaint(
            painter: SimpleSketcher(widget.uiEditableFileLines),
            child: Container(),
          ),
        ),
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
                bottomIcon(MdiIcons.sizeL, isSelected: size == 6,onTap: () {
                  setState(() {
                    size = 6;
                  });
                }),
                bottomIcon(MdiIcons.sizeXl, isSelected: size == 9,onTap: () {
                  setState(() {
                    size = 9;
                  });
                }),
                bottomIcon(MdiIcons.sizeXxl, isSelected: size == 12,onTap: () {
                  setState(() {
                    size = 12;
                  });
                }),
              ],
            ),
          ),
        ),
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

// Align(
//   alignment: Alignment.center,
//   child: LayoutBuilder(
//     builder: (BuildContext context, BoxConstraints constraints) {
//       final paintingAreaWidth = constraints.maxWidth * 0.75;  // 75% of screen width
//       final paintingAreaHeight = constraints.maxHeight * 0.75;  // 75% of screen height
//       final offsetX = (constraints.maxWidth - paintingAreaWidth) / 2; // horizontal offset
//       final offsetY = (constraints.maxHeight - paintingAreaHeight) / 2; // vertical offset
//       return Container(
//         width: paintingAreaWidth,
//         height: paintingAreaHeight,
//         child:
//       );
//     },
//   ),
// ),
