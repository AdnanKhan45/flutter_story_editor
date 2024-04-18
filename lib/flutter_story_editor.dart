library flutter_story_editor;

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_story_editor/src/controller/controller.dart';
import 'package:flutter_story_editor/src/utils/utils.dart';

import 'src/const/filters.dart';
import 'src/enums/story_editing_modes.dart';
import 'src/models/stroke.dart';
import 'src/views/main_control_views/image_view.dart';
import 'src/views/main_control_views/main_controls_view.dart';
import 'src/views/main_control_views/trimmer_view.dart';
import 'src/views/paint_control_views/paint_controls_view.dart';
import 'src/views/sticker_control_views/sticker_control_view.dart';
import 'src/widgets/draggable_sticker_widget.dart';
import 'src/widgets/draggable_text_widget.dart';


class FlutterStoryEditor extends StatefulWidget {
  final List<File>? selectedFiles; // Holds the files selected for editing.
  final Function(List<File>)? onSaveClickListener; // Callback when save action is triggered.
  final TextEditingController? captionController; // Controller for handling caption text input.
  final FlutterStoryEditorController controller; // Custom controller for managing editor state.
  final bool? trimVideoOnAdjust; // Flag to determine if video should be trimmed when adjusted.
  const FlutterStoryEditor(
      {super.key, this.selectedFiles, this.onSaveClickListener, this.captionController, required this.controller, this.trimVideoOnAdjust=false});

  @override
  State<FlutterStoryEditor> createState() => _FlutterStoryEditorState();
}

class _FlutterStoryEditorState extends State<FlutterStoryEditor> {
  // Stream controller for broadcasting undo drawing actions.
  StreamController<bool> drawingUndoController = StreamController<bool>.broadcast();

  // List to keep track of edit actions for undo functionality.
  List<EditAction> editActions = [];


  @override
  void dispose() {
    /// Cleans up resources and controllers on widget disposal.
    drawingUndoController.close();
    widget.controller.setStoryEditingModeSelected = StoryEditingModes.paint;
    keyboardSubscription.cancel();
    super.dispose();
  }

  void undo(List<Stroke> lines) {
    // Removes the last drawn line from the list, effectively undoing the last draw action.
    if (lines.isNotEmpty) {
      setState(() {
        lines.removeLast();
      });
    }
  }

  void onUndoClick() {
    // Trigger for undo action, adds a signal to the drawingUndoController.
    drawingUndoController.add(true);
  }

  List<GlobalKey> _imageKeys = []; // Keys for uniquely identifying image widgets within the editor.
  final Map<File, Uint8List?> _thumbnails = {}; // Cache for storing generated thumbnails.
  int currentPageIndex = 0; // Tracks the current page index within the story editor.
  List<List<double>> selectedFilters = []; // Stores filters applied to each story page.
  List<File>? uiViewEditableFiles; // Holds the editable files for UI display.
  bool isSaving = false; // Flag to indicate save operation is in progress.
  bool isKeyboardFocused = false; // Tracks the keyboard visibility state.
  late StreamSubscription<bool> keyboardSubscription; // Subscription to keyboard visibility changes.


  @override
  void initState() {
    super.initState();
    // Initializes and sets up necessary controllers and listeners.

    drawingUndoController.stream.listen((_) => undo(widget.controller.uiEditableFileLines[currentPageIndex]));

    uiViewEditableFiles = List<File>.from(widget.selectedFiles!);

    widget.controller.initializeUiEditableFileLines(widget.selectedFiles!.length);

    _imageKeys = List.generate(widget.selectedFiles!.length, (index) => GlobalKey());

    selectedFilters = List.generate(widget.selectedFiles!.length, (index) => noFiler);

    textList = ValueNotifier(List.generate(widget.selectedFiles!.length, (index) => []));
    stickersList = ValueNotifier(List.generate(widget.selectedFiles!.length, (index) => []));

    // Listening to keyboard visibility

    captionFocusNode.addListener(() {
      if (captionFocusNode.hasFocus) {
        keyboardSubscription.cancel();
      }
    });

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        isKeyboardFocused = visible;
      });
    });
  }

  // textList to store Text for each page.
  ValueNotifier<List<List<DraggableTextWidget>>> textList = ValueNotifier<List<List<DraggableTextWidget>>>([]);
  // stickersList to store Stickers for each page.
  ValueNotifier<List<List<DraggableStickerWidget>>> stickersList = ValueNotifier<List<List<DraggableStickerWidget>>>([]);

  final PageController _pageController = PageController();

  // Controlling caption field
  FocusNode captionFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: stickersList,
        builder: (context, stickerListValue, child) {
          return ValueListenableBuilder(
            valueListenable: textList,
            builder: (context, textListValue, child) {
              return ValueListenableBuilder(
                valueListenable: widget.controller.editingModeNotifier,
                builder: (BuildContext context, StoryEditingModes mode, Widget? child) {
                  return PopScope(
                    canPop: mode == StoryEditingModes.none,
                    onPopInvoked: (bool isSystemPop) {
                      // Controlling state
                      // Return to [StoryEditingModes.NONE] state only if selected state is not NONE.
                      if (!isSystemPop) {
                        widget.controller.setStoryEditingModeSelected = StoryEditingModes.none;
                      }
                    },
                    child: Container(
                      color: Colors.black,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                              width: double.infinity,
                              child: PageView(
                                physics: isKeyboardFocused || widget.controller.editingModeSelected != StoryEditingModes.none
                                    ? const NeverScrollableScrollPhysics()
                                    : const ScrollPhysics(),
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    currentPageIndex = index;
                                  });
                                },
                                children: uiViewEditableFiles!.map((singleStory) {
                                  int storyIndex = uiViewEditableFiles!.indexOf(singleStory);
                                  // if the selected file was video show [TrimmerView]
                                  if (isVideo(singleStory)) {
                                    return TrimmerView(
                                      lines: widget.controller.uiEditableFileLines[storyIndex],
                                      trimOnAdjust: widget.trimVideoOnAdjust,
                                      onTrimCompleted: (file) async {
                                        await generateThumbnail(file)
                                            .then((generatedThumbnail) {
                                          setState(() {
                                            _thumbnails[file] = generatedThumbnail;
                                          });
                                        });
                                        setState(() {
                                          widget.selectedFiles![storyIndex] = file;
                                        });
                                      },
                                      key: ValueKey(singleStory.path),
                                      file: singleStory,
                                      pageController: _pageController,
                                      pageIndex: storyIndex,
                                    );
                                  } else {
                                    // if the selected file was image show [ImageView]
                                    return GestureDetector(
                                      onVerticalDragUpdate: (details) {
                                        if (details.delta.dy < 0) {
                                          widget.controller.setStoryEditingModeSelected = StoryEditingModes.filters;
                                        } else if (details.delta.dy > 0) {
                                          widget.controller.setStoryEditingModeSelected = StoryEditingModes.none;
                                        }
                                      },
                                      child: RepaintBoundary(
                                        key: _imageKeys[storyIndex],
                                        child: ImageView(
                                          storyIndex: storyIndex,
                                          textList: textListValue,
                                          stickerList: stickerListValue,
                                          lines: widget.controller.uiEditableFileLines[storyIndex],
                                          controller: widget.controller,
                                          file: singleStory,
                                          filter: selectedFilters[storyIndex],
                                        ),
                                      ),
                                    );
                                  }
                                }).toList(),
                              )),

                          // If selected mode was PAINT show paint control views.
                          if (mode == StoryEditingModes.paint)
                            PaintControlsView(
                              onDoneClickListener: () async {
                                widget.controller.setStoryEditingModeSelected = StoryEditingModes.none;

                                await generateThumbnail(uiViewEditableFiles![currentPageIndex]).then((generatedThumbnail) {
                                  setState(() {
                                    _thumbnails[uiViewEditableFiles![currentPageIndex]] = generatedThumbnail;
                                  });
                                });
                              },
                              onUndoClickListener: () {
                                undo(widget.controller.uiEditableFileLines[currentPageIndex]);
                                onUndoClick();

                                setState(() {
                                  if (widget.controller.uiEditableFileLines[currentPageIndex].isNotEmpty) {
                                    widget.controller.uiEditableFileLines[currentPageIndex] =
                                    List.from(widget.controller.uiEditableFileLines[currentPageIndex])..removeLast();
                                    widget.controller.setUiEditableFileLines(
                                        currentPageIndex, widget.controller.uiEditableFileLines[currentPageIndex]);
                                  }
                                });
                              },
                              uiEditableFileLines: widget.controller.uiEditableFileLines[currentPageIndex],
                              onPointerDownUpdate: (newLine) {
                                setState(() {
                                  editActions.add(EditAction(item: newLine, type: 'line', pageIndex: currentPageIndex));

                                  widget.controller.uiEditableFileLines[currentPageIndex] = [
                                    ...widget.controller.uiEditableFileLines[currentPageIndex],
                                    newLine
                                  ];
                                  widget.controller.setUiEditableFileLines(
                                      currentPageIndex, widget.controller.uiEditableFileLines[currentPageIndex]);
                                });

                              },
                              controller: widget.controller,
                              selectedFile: widget.selectedFiles![currentPageIndex],
                            )

                          // If selected mode was STICKERS show sticker control views.
                          else if (mode == StoryEditingModes.stickers)
                            StickerControlView(
                                controller: widget.controller,
                                onStickerClickListener: (stickerPath) {

                                  widget.controller.setStoryEditingModeSelected = StoryEditingModes.none;

                                  setState(() {



                                    if (stickersList.value.length <= currentPageIndex) {
                                      stickersList.value.add([]);
                                    }

                                    final draggableSticker = DraggableStickerWidget(
                                      stickerPath: stickerPath,
                                      key: UniqueKey(),
                                    );

                                    stickersList.value[currentPageIndex].add(
                                      draggableSticker,
                                    );

                                    editActions.add(EditAction(item: draggableSticker, type: 'sticker', pageIndex: currentPageIndex));

                                  });

                                }
                            )

                          // If selected mode was TEXT show text control views,
                          // Here I returned Container() because these controls are
                          // handled within DraggableStickerWidget

                          else if (mode == StoryEditingModes.text)
                              Container()

                              // If selected mode was NONE show main control views
                            else
                              MainControlsView(
                                stickerList: stickerListValue,
                                onStickersClickListener: () {
                                  widget.controller.setStoryEditingModeSelected = StoryEditingModes.stickers;
                                },
                                captionFocusNode: captionFocusNode,
                                textList: textListValue,
                                isFocused: isKeyboardFocused,
                                lines: widget.controller.uiEditableFileLines[currentPageIndex],
                                onTextClickListener: () {
                                  widget.controller.setStoryEditingModeSelected = StoryEditingModes.text;

                                  setState(() {
                                    if (textList.value.length <= currentPageIndex) {
                                      textList.value.add([]);
                                    }

                                    final draggableText  = DraggableTextWidget(
                                      controller: widget.controller,
                                      textList: textList.value[currentPageIndex],
                                      key: UniqueKey(),
                                    );

                                    textList.value[currentPageIndex].add(
                                        draggableText
                                    );

                                    editActions.add(EditAction(item: draggableText, type: 'text', pageIndex: currentPageIndex));

                                  });
                                },
                                onPaintClickListener: () {
                                  widget.controller.setFileSelected = widget.selectedFiles![currentPageIndex];
                                  widget.controller.setFilterSelected = selectedFilters[currentPageIndex];

                                  widget.controller.setStoryEditingModeSelected = StoryEditingModes.paint;
                                },
                                currentPageIndex: currentPageIndex,
                                pageController: _pageController,
                                onUndoClickListener: () {

                                  // Handling undo action based on the item which was added last to the list

                                  if (editActions.isNotEmpty) {
                                    EditAction lastAction = editActions.removeLast();
                                    setState(() {
                                      switch (lastAction.type) {
                                        case 'text':
                                          textList.value[currentPageIndex].remove(lastAction.item);
                                          break;
                                        case 'sticker':
                                          stickersList.value[currentPageIndex].remove(lastAction.item);
                                          break;
                                        case 'filter':
                                          selectedFilters[currentPageIndex] = noFiler;
                                          break;
                                        case 'line':
                                          undo(widget.controller.uiEditableFileLines[currentPageIndex]);
                                          onUndoClick();
                                          widget.controller.uiEditableFileLines[currentPageIndex] =
                                          List.from(widget.controller.uiEditableFileLines[currentPageIndex])..remove(lastAction.item);
                                          widget.controller.setUiEditableFileLines(
                                              currentPageIndex, widget.controller.uiEditableFileLines[currentPageIndex]);

                                          break;
                                      }

                                    });
                                  }
                                },
                                onImageCrop: (croppedImage) {
                                  setState(() {
                                    uiViewEditableFiles![currentPageIndex] = croppedImage;
                                  });
                                },
                                onFilterChange: (filter) {
                                  setState(() {
                                    editActions.add(EditAction(item: filter, type: 'filter', pageIndex: currentPageIndex));
                                    selectedFilters[currentPageIndex] = filter;
                                  });
                                },
                                selectedFilters: selectedFilters,
                                uiViewEditableFiles: uiViewEditableFiles!,
                                onSaveClickListener: () async {
                                  setState(() => isSaving = true);

                                  for (int i = 0; i < widget.selectedFiles!.length; i++) {
                                    if (!isVideo(widget.selectedFiles![i])) {
                                      await _pageController.animateToPage(i,
                                          duration: const Duration(milliseconds: 300), curve: Curves.ease);

                                      // Waiting for page transition
                                      await Future.delayed(const Duration(milliseconds: 500));

                                      File? snapshotFile = await convertWidgetToImage(_imageKeys[i]);
                                      if (snapshotFile != null) {
                                        setState(() {
                                          widget.selectedFiles![i] = snapshotFile;
                                        });
                                      }
                                    }
                                  }

                                  setState(() => isSaving = false);

                                  if (widget.selectedFiles != null && widget.selectedFiles!.isNotEmpty) {
                                    widget.onSaveClickListener!(widget.selectedFiles!);
                                  }
                                },
                                selectedFiles: widget.selectedFiles,
                                controller: widget.controller,
                                captionController: widget.captionController,
                                isSaving: isSaving,
                              ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
    );
  }
}

// EditAction item to handle undo action.
class EditAction {
  final dynamic item;
  final String type;
  final int pageIndex;

  EditAction({required this.item, required this.type, required this.pageIndex});
}

