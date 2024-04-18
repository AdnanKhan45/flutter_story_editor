// Import necessary Dart and Flutter packages.

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/controller/controller.dart';
import 'package:flutter_story_editor/src/models/simple_sketecher.dart';
import 'package:flutter_story_editor/src/models/stroke.dart';
import 'package:flutter_story_editor/src/theme/style.dart';
import 'package:flutter_story_editor/src/utils/utils.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

class ThumbnailView extends StatefulWidget {
  final List<File> selectedFiles; // List of files selected for editing.
  final int currentPageIndex; // Current page index to indicate the selected thumbnail.
  final Map<File, Uint8List?>? thumbnails; // Optional map for storing thumbnails of video files.
  final List<List<double>>? selectedFilters; // Optional list for storing filters applied to each thumbnail.
  final Function(int) onThumbnailTapListener; // Callback function to handle thumbnail taps.
  final FlutterStoryEditorController controller; // Controller to manage editing state and interactions.

  const ThumbnailView({
    super.key,
    required this.selectedFiles,
    required this.currentPageIndex,
    required this.onThumbnailTapListener,
    this.thumbnails,
    this.selectedFilters,
    required this.controller,
  });

  @override
  State<ThumbnailView> createState() => _ThumbnailViewState();
}

class _ThumbnailViewState extends State<ThumbnailView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            children: widget.selectedFiles.map((e) {
              int fileIndex = widget.selectedFiles.indexOf(e);
              return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.5,
                      color: widget.currentPageIndex == fileIndex
                          ? tealColor
                          : Colors.transparent),
                ),
                child: GestureDetector(
                  onTap: () => widget.onThumbnailTapListener(fileIndex),
                  child: ThumbnailViewItem(
                    controller: widget.controller,
                    index: fileIndex,
                    image: e,
                    selectedFiles: widget.selectedFiles,
                    selectedFilters: widget.selectedFilters,
                    thumbnails: widget.thumbnails,
                  ),
                ),
              );
            }).toList(),
          )),
    );
  }
}

class ThumbnailViewItem extends StatefulWidget {
  final File image; // File for which the thumbnail is displayed.
  final FlutterStoryEditorController controller; // Controller to manage editing state and interactions.
  final int index; // Index of the thumbnail in the list.
  final Map<File, Uint8List?>? thumbnails; // Optional map for storing thumbnails of video files.
  final List<List<double>>? selectedFilters; // Optional list for storing filters applied to each thumbnail.
  final List<File>? selectedFiles; // Optional list of files being edited.
  const ThumbnailViewItem(
      {super.key,
      required this.index,
      this.thumbnails,
      this.selectedFilters,
      this.selectedFiles,
      required this.image,
      required this.controller});

  @override
  State<ThumbnailViewItem> createState() => _ThumbnailViewItemState();
}

class _ThumbnailViewItemState extends State<ThumbnailViewItem> {

  @override
  Widget build(BuildContext context) {


    double scaleFactor = min(
      50.0 / MediaQuery.of(context).size.width,
      50.0 / MediaQuery.of(context).size.height,
    );

    return ValueListenableBuilder<List<List<Stroke>>>(
      valueListenable: widget.controller.uiEditableFileLinesNotifier,
      builder: (BuildContext context, List<List<Stroke>> lines, Widget? child) {


        List<Stroke> scaledLines = lines[widget.index].map((line) {



          return Stroke(
            line.points.map((point) {
              return PointVector(
                  point.x * scaleFactor * 1.8, point.y * scaleFactor * 0.9, point.pressure);
            }).toList(),
            line.color,
            StrokeOptions(
              size: 1
            ),
          );
        }).toList();

        if (isVideo(widget.image)) {
          if (widget.thumbnails != null) {
            return widget.thumbnails![widget.image] == null
                ? Container()
                : Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Image.memory(
                          widget.thumbnails![widget.image]!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      CustomPaint(

                        painter: SimpleSketcher(scaledLines),
                        child: Container(),
                      )
                    ],
                  );
          } else {
            return Container(); // If thumbnail is not ready yet, just display an empty container.
          }
        } else {
          return ColorFiltered(
            colorFilter:
                ColorFilter.matrix(widget.selectedFilters![widget.index]),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.file(
                    widget.selectedFiles != null
                        ? widget.selectedFiles![widget.index]
                        : widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
                CustomPaint(
                  size: Size(
                    50.0 * MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
                    50.0,
                  ),
                  painter: SimpleSketcher(scaledLines),
                  child: Container(),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
