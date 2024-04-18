
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/const/filters.dart';
import 'package:flutter_story_editor/src/controller/controller.dart';
import 'package:flutter_story_editor/src/models/stroke.dart';
import 'package:flutter_story_editor/src/utils/utils.dart';
import 'package:flutter_story_editor/src/widgets/draggable_sticker_widget.dart';
import 'package:flutter_story_editor/src/widgets/draggable_text_widget.dart';
// TopView is a StatefulWidget that provides the top bar interface for story editing controls.
class TopView extends StatefulWidget {
  final File selectedFile; // The currently selected file for editing.
  final VoidCallback onTapCropListener; // Callback for handling crop operations.
  final int currentPageIndex; // Index of the current page being edited.
  final List<List<double>> selectedFilters; // Current filter applied to each file page.
  final List<List<DraggableTextWidget>> textList; // List of text widgets added to each file page.
  final List<List<DraggableStickerWidget>> stickerList; // List of sticker widgets added to each file page.
  final VoidCallback onUndoClickListener; // Callback for undo operations.
  final VoidCallback onPaintClickListener; // Callback for activating the paint editing mode.
  final VoidCallback onTextClickListener; // Callback for activating the text editing mode.
  final VoidCallback onStickersClickListener; // Callback for activating the stickers editing mode.
  final List<Stroke> lines; // List of all drawing strokes on the current page.
  final FlutterStoryEditorController controller; // Controller for managing editor state.

  // Constructor for initializing TopView with required parameters.
  const TopView({
    super.key,
    required this.selectedFile,
    required this.onTapCropListener,
    required this.currentPageIndex,
    required this.selectedFilters,
    required this.onUndoClickListener,
    required this.onPaintClickListener,
    required this.lines,
    required this.controller,
    required this.onTextClickListener,
    required this.textList,
    required this.onStickersClickListener,
    required this.stickerList
  });

  @override
  State<TopView> createState() => _TopViewState();
}

// State class for TopView, handles the rendering of the top toolbar.
class _TopViewState extends State<TopView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: Platform.isIOS ? 60 : 40), // Padding adjusted for platform differences.
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between controls and the close icon.
            children: [
              // Close icon to exit the editor.
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close_outlined,
                    size: 30,
                    color: Colors.white,
                  )),
              // Conditional rendering if the selected file is not a video.
              if (!isVideo(widget.selectedFile))
                Row(
                  children: [
                    // Undo icon is shown if there are any changes that can be undone.
                    widget.selectedFilters[widget.currentPageIndex] != noFiler || widget.lines.isNotEmpty || widget.textList[widget.currentPageIndex].isNotEmpty || widget.stickerList[widget.currentPageIndex].isNotEmpty ? GestureDetector(
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
                    // Crop icon for image editing.
                    GestureDetector(
                        onTap: widget.onTapCropListener,
                        child: const Icon(
                          Icons.crop,
                          size: 30,
                          color: Colors.white,
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    // Icon for accessing sticker controls.
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
                    // Icon for accessing text controls.
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
                    // Icon for accessing painting controls.
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
