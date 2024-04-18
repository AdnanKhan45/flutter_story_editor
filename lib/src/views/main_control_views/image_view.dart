import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/const/filters.dart';
import 'package:flutter_story_editor/src/controller/controller.dart';
import 'package:flutter_story_editor/src/models/simple_sketecher.dart';
import 'package:flutter_story_editor/src/models/stroke.dart';
import 'package:flutter_story_editor/src/widgets/draggable_sticker_widget.dart';
import 'package:flutter_story_editor/src/widgets/draggable_text_widget.dart';

class ImageView extends StatefulWidget {
  final File file;
  final List<double>? filter;
  final FlutterStoryEditorController controller;
  final List<Stroke> lines;
  final int storyIndex;

  final List<List<DraggableTextWidget>> textList;
  final List<List<DraggableStickerWidget>> stickerList;

  const ImageView(
      {super.key,
      required this.file,
      this.filter,
      required this.controller,
      required this.lines, required this.textList, required this.storyIndex, required this.stickerList});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView>  {

  @override
  Widget build(BuildContext context) {

    return Stack(

      alignment: Alignment.center,
      children: [

        Row(
          children: [
            Expanded(child: ColorFiltered(colorFilter: ColorFilter.matrix(widget.filter ?? NO_FILTER),child: Image.file(widget.file, fit: BoxFit.cover))),
          ],
        ),

        CustomPaint(
          painter: SimpleSketcher(widget.lines),
          child: Container(),
        ),

        ...widget.stickerList[widget.storyIndex].map((draggableStickerWidget) {
          return draggableStickerWidget;
        }),

        ...widget.textList[widget.storyIndex].map((draggableTextWidget) {
          return draggableTextWidget;
        }),

      ],
    );
  }

}














