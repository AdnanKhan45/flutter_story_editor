import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/const/filters.dart';
import 'package:flutter_story_editor/src/controller/controller.dart';
import 'package:flutter_story_editor/src/models/simple_sketecher.dart';
import 'package:flutter_story_editor/src/models/stroke.dart';
import 'package:flutter_story_editor/src/widgets/draggable_sticker_widget.dart';
import 'package:flutter_story_editor/src/widgets/draggable_text_widget.dart';

// ImageView is a StatefulWidget that displays an image along with applied filters, stickers, and text overlays.
class ImageView extends StatefulWidget {
  final File file; // The image file to display.
  final List<double>? filter; // The color filter to apply on the image.
  final FlutterStoryEditorController controller; // Controller for managing the story editing state.
  final List<Stroke> lines; // List of strokes for drawing on the image.
  final int storyIndex; // Index of the current story.
  final List<List<DraggableTextWidget>> textList; // List of text widgets added to the current story.
  final List<List<DraggableStickerWidget>> stickerList; // List of sticker widgets added to the current story.

  // Constructor for initializing ImageView with required parameters.
  const ImageView({
    super.key,
    required this.file,
    this.filter,
    required this.controller,
    required this.lines,
    required this.textList,
    required this.storyIndex,
    required this.stickerList
  });

  @override
  State<ImageView> createState() => _ImageViewState();
}

// State class for ImageView, handling the display and interaction of the image, its filters, and overlays.
class _ImageViewState extends State<ImageView>  {

  @override
  Widget build(BuildContext context) {
    // Builds the UI components layered over each other in a stack.
    return Stack(
      alignment: Alignment.center,
      children: [
        // Display the image with an optional color filter applied.
        Row(
          children: [
            Expanded(child: ColorFiltered(
                colorFilter: ColorFilter.matrix(widget.filter ?? noFiler), // Apply the matrix filter or default to no filter.
                child: Image.file(widget.file, fit: BoxFit.cover) // Display the image file covering its container.
            )),
          ],
        ),

        // Custom painter that draws the strokes on the image.
        CustomPaint(
          painter: SimpleSketcher(widget.lines),
          child: Container(),
        ),

        // Display draggable sticker widgets.
        ...widget.stickerList[widget.storyIndex].map((draggableStickerWidget) {
          return draggableStickerWidget; // Render each sticker widget from the list.
        }),

        // Display draggable text widgets.
        ...widget.textList[widget.storyIndex].map((draggableTextWidget) {
          return draggableTextWidget; // Render each text widget from the list.
        }),

      ],
    );
  }

}








