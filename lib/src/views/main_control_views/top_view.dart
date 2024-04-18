
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/const/filters.dart';
import 'package:flutter_story_editor/src/controller/controller.dart';
import 'package:flutter_story_editor/src/models/stroke.dart';
import 'package:flutter_story_editor/src/utils/utils.dart';
import 'package:flutter_story_editor/src/widgets/draggable_sticker_widget.dart';
import 'package:flutter_story_editor/src/widgets/draggable_text_widget.dart';
class TopView extends StatefulWidget {
  final File selectedFile;
  final VoidCallback onTapCropListener;
  final int currentPageIndex;
  final List<List<double>> selectedFilters;
  final List<List<DraggableTextWidget>> textList;
  final List<List<DraggableStickerWidget>> stickerList;
  final VoidCallback onUndoClickListener;
  final VoidCallback onPaintClickListener;
  final VoidCallback onTextClickListener;
  final VoidCallback onStickersClickListener;
  final List<Stroke> lines;
  final FlutterStoryEditorController controller;
  const TopView({super.key, required this.selectedFile, required this.onTapCropListener, required this.currentPageIndex, required this.selectedFilters, required this.onUndoClickListener, required this.onPaintClickListener, required this.lines, required this.controller, required this.onTextClickListener, required this.textList, required this.onStickersClickListener, required this.stickerList});

  @override
  State<TopView> createState() => _TopViewState();
}

class _TopViewState extends State<TopView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: 15, vertical: Platform.isIOS ? 60 : 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close_outlined,
                    size: 30,
                    color: Colors.white,
                  )),
              if(!isVideo(widget.selectedFile))
              Row(
                children: [
                  widget.selectedFilters[widget.currentPageIndex] != NO_FILTER || widget.lines.isNotEmpty || widget.textList[widget.currentPageIndex].isNotEmpty || widget.stickerList[widget.currentPageIndex].isNotEmpty ? GestureDetector(
                    onTap: widget.onUndoClickListener,
                    child: const Icon(
                      Icons.undo,
                      size: 30,
                      color: Colors.white,
                    ),
                  ) : Container(),
                  const SizedBox(
                    width: 20,
                  ),
                  isVideo(widget.selectedFile)
                      ? const Text("")
                      : GestureDetector(
                      onTap:widget.onTapCropListener,
                      child: const Icon(
                        Icons.crop,
                        size: 30,
                        color: Colors.white,
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: widget.onStickersClickListener,
                    child: const Icon(
                      Icons.emoji_emotions_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: widget.onTextClickListener,
                    child: const Icon(
                      Icons.title,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: widget.onPaintClickListener,
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

}
