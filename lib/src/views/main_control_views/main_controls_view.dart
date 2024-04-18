import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/controller/controller.dart';
import 'package:flutter_story_editor/src/enums/story_editing_modes.dart';
import 'package:flutter_story_editor/src/models/stroke.dart';
import 'package:flutter_story_editor/src/utils/utils.dart';
import 'package:flutter_story_editor/src/views/main_control_views/filters_view.dart';
import 'package:flutter_story_editor/src/widgets/draggable_sticker_widget.dart';
import 'package:flutter_story_editor/src/widgets/draggable_text_widget.dart';

import 'caption_view.dart';
import 'filter_text_view.dart';
import 'thumbnail_view.dart';
import 'top_view.dart';

class MainControlsView extends StatefulWidget {
  final List<File>? selectedFiles;
  final VoidCallback? onSaveClickListener;
  final TextEditingController? captionController;
  final FlutterStoryEditorController controller;
  final List<File> uiViewEditableFiles;
  final List<List<double>> selectedFilters;
  final List<List<DraggableTextWidget>> textList;
  final List<List<DraggableStickerWidget>> stickerList;
  final Function(List<double>) onFilterChange;
  final Function(File) onImageCrop;
  final VoidCallback onUndoClickListener;
  final VoidCallback onPaintClickListener;
  final VoidCallback onTextClickListener;
  final VoidCallback onStickersClickListener;
  final PageController pageController;
  final int currentPageIndex;
  final List<Stroke> lines;
  final bool isSaving;
  final bool isFocused;
  final FocusNode? captionFocusNode;

  const MainControlsView(
      {super.key,
      this.selectedFiles,
      this.onSaveClickListener,
      this.captionController,
      required this.controller,
      required this.isFocused,
      required this.uiViewEditableFiles,
      required this.selectedFilters,
      required this.onFilterChange,
      required this.onImageCrop,
      required this.onUndoClickListener,
      required this.pageController,
      required this.currentPageIndex,
      required this.onPaintClickListener,
      required this.onTextClickListener,
      required this.lines,
      required this.isSaving,
        required this.textList,
        this.captionFocusNode,
        required this.onStickersClickListener, required this.stickerList,
       });

  @override
  State<MainControlsView> createState() => _MainControlsViewState();
}

class _MainControlsViewState extends State<MainControlsView> {
  final Map<File, Uint8List?> _thumbnails = {};

  List<File>? originalFiles;

  static const double maxVideoSizeMB = 50; // Maximum allowed video size in MB
  static const double maxImageSizeMB = 5; // Maximum allowed image size in MB

  void generateVideoFilesThumbnails() async {
    for (var file in widget.selectedFiles ?? []) {
      if (isVideo(file)) {
        var generatedThumbnail = await generateThumbnail(file);
        if (mounted) {
          setState(() {
            _thumbnails[file] = generatedThumbnail;
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    generateVideoFilesThumbnails();

    for (var file in widget.selectedFiles!) {
      final bytes = file.readAsBytesSync();
      final sizeInMB = bytes.lengthInBytes / (1024 * 1024);

      if (isVideo(file) && sizeInMB > maxVideoSizeMB) {
        // Handle large video
        Navigator.pop(context);
        // Perhaps remove from the list or show a dialog
      }

      if (!isVideo(file) && sizeInMB > maxImageSizeMB) {
        // Handle large image
        Navigator.pop(context);
        // Perhaps remove from the list or show a dialog
      }
    }

    originalFiles = List<File>.from(widget.selectedFiles!);
  }

  void _cropImage(BuildContext context) {
    cropImage(
      context,
      file: originalFiles![widget.currentPageIndex],
    ).then((croppedFile) async {
      if (croppedFile != null) {
        File croppedImage = File(croppedFile.path);
        widget.onImageCrop(croppedImage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        for (File file in widget.selectedFiles!)
          if (!(isVideo(file)))
            Align(
              alignment: Alignment.topCenter,
              child: _buildTop(),
            ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildBottom(),
        ),
      ],
    );
  }

  Widget _buildTop() {
    return TopView(
      stickerList: widget.stickerList,
      textList: widget.textList,
      controller: widget.controller,
      lines: widget.lines,
      onTextClickListener: () {
        widget.onTextClickListener();
      },
      onStickersClickListener: () {
        widget.onStickersClickListener();
      },
      onPaintClickListener: () {
        widget.onPaintClickListener();
      },
      onUndoClickListener: widget.onUndoClickListener,
      currentPageIndex: widget.currentPageIndex,
      selectedFilters: widget.selectedFilters,
      selectedFile: widget.selectedFiles![widget.currentPageIndex],
      onTapCropListener: () {
        _cropImage(context);
      },
    );
  }

  Widget _buildBottom() {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          if(widget.isFocused == false)
            isVideo(widget.selectedFiles![widget.currentPageIndex])
              ? Container()
              : FilterTextView(
                  showFilters: widget.controller.editingModeSelected,
                  onChange: (showFiltersView) {
                    widget.controller.setStoryEditingModeSelected = showFiltersView;
                  },
                ),
          const SizedBox(
            height: 5,
          ),
          Column(
            children: [
              if(widget.isFocused == false)
                ThumbnailView(
                controller: widget.controller,
                onThumbnailTapListener: (thumbnailItemIndex) {
                  widget.pageController.jumpToPage(thumbnailItemIndex);
                },
                currentPageIndex: widget.currentPageIndex,
                thumbnails: _thumbnails,
                selectedFiles: widget.uiViewEditableFiles,
                selectedFilters: widget.selectedFilters,
              ),
              const SizedBox(
                height: 10,
              ),

              if (widget.controller.editingModeSelected == StoryEditingModes.FILTERS)
                FiltersView(
                  onFilterChange: (filter) {
                    widget.onFilterChange(filter);
                  },
                  selectedFilters: widget.selectedFilters,
                  currentPageIndex: widget.currentPageIndex,
                  selectedFiles: originalFiles,
                )
              else
                if(widget.isFocused == false)
                CaptionView(
                  focusNode: widget.captionFocusNode,
                  isSaving: widget.isSaving,
                  captionController: widget.captionController!,
                  onSaveClickListener: widget.onSaveClickListener!,
                )
            ],
          ),
        ],
      ),
    );
  }
}
