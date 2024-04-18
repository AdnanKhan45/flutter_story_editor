import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_story_editor/src/const/filters.dart';
import 'package:flutter_story_editor/src/controller/controller.dart';
import 'package:flutter_story_editor/src/enums/story_editing_modes.dart';
import 'package:flutter_story_editor/src/theme/style.dart';
import 'package:flutter_story_editor/src/views/text_control_views/text_control_view.dart';
import 'package:flutter_story_editor/src/widgets/hue_color_picker_slider.dart';

class DraggableTextWidget extends StatefulWidget {
  final List<Widget> textList;
  final FlutterStoryEditorController controller;
  const DraggableTextWidget({super.key, required this.textList, required this.controller});

  @override
  State<DraggableTextWidget> createState() => _DraggableTextWidgetState();
}

class _DraggableTextWidgetState extends State<DraggableTextWidget> with AutomaticKeepAliveClientMixin {
  FocusNode focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  late final MaterialStatesController _statesController;

  /// [isKeyboardFocused] to control keyboard visibility
  bool isKeyboardFocused = false;
  /// [isFocusField] to control field focus
  bool isFocusField = false;

  /// [isAlignedLeft] & [isAlignedRight] to alignment of text
  bool isAlignedLeft = false;
  bool isAlignedRight = false;

  /// [selectedTextStyle] to control styling of text
  TextStyle selectedTextStyle = fontStyles[0];

  /// [offset] to control positioning of text
  Offset offset = const Offset(0, 0);

  /// [leftPosition] to control left positioning of text
  double leftPosition = 0.0;

  /// [textColor] to control color of text
  HSVColor textColor = HSVColor.fromColor(Colors.white);

  /// [fontSize] to control sizing of text
  double fontSize = 20;

 late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {

    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () => focusNode.requestFocus());


    _statesController = MaterialStatesController();

    // Hypothetical listener setup to respond to state changes

    _statesController.addListener(() {
      Set<MaterialState> states = _statesController.value;
      if (states.contains(MaterialState.focused)) {

        /// Listening to field states through [_statesController] and updating positioning and field focus
        if(mounted) {
          setState(() {
            isFocusField = true;
            offset = const Offset(0.0, 0.0);
            if(isAlignedLeft == true) {
              leftPosition = -150.0;
            } else if(isAlignedRight == true) {
              leftPosition = 150.0;
            } else {
              leftPosition = 0.0;
            }
          });
        }

      } else {

        setState(() {
          isFocusField = false;
        });

        if(mounted) {
          setState(() {
          if(_textEditingController.text.isEmpty) {
            widget.textList.removeLast();
          }
        });
        }

      }
    });


    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {

      if(mounted) {
        setState(() {
          isKeyboardFocused = visible;
        });
      }

    });

  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    super.build(context);
    return ValueListenableBuilder(
      valueListenable: widget.controller.editingModeNotifier,
      builder: (context, mode, child) {

        return Stack(
          children: [
            if (mode == StoryEditingModes.text && isFocusField)
              Container(
                color: Colors.black.withOpacity(.5),
              ),
            Positioned(
              left: leftPosition,
              top: offset.dy,
              right: offset == const Offset(0, 0) ? 0 : null,
              bottom: offset == const Offset(0, 0) ? 100 : null,
              child: Align(
                alignment: Alignment.center,
                child: Draggable(
                  feedback: Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: IntrinsicWidth(
                        child: TextField(
                          maxLines: 2,
                          textInputAction: TextInputAction.newline,
                          statesController: _statesController,
                          textAlign: TextAlign.center,
                          onTap: () {
                            widget.controller.setStoryEditingModeSelected = StoryEditingModes.text;
                          },
                          onTapOutside: (event) {
                            if (_textEditingController.text.isEmpty) {
                              widget.controller.setStoryEditingModeSelected = StoryEditingModes.none;
                              focusNode.unfocus();
                            }
                          },
                          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500, color: textColor.toColor())
                              .merge(selectedTextStyle).copyWith(color: textColor.toColor()),
                          focusNode: focusNode,
                          controller: _textEditingController,
                          autofocus: false,
                          cursorColor: tealColor,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Add text",
                              hintStyle: TextStyle(fontSize: 20, color: Colors.grey)
                          ),
                        ),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(),
                  onDragEnd: (details) {
                    setState(() {
                      offset = Offset(details.offset.dx, details.offset.dy);
                      leftPosition = details.offset.dx;
                      focusNode.unfocus();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: IntrinsicWidth(
                      child: TextField(
                        maxLines: 2,
                        textInputAction: TextInputAction.newline,
                        statesController: _statesController,
                        textAlign: TextAlign.center,
                        onTap: () {
                          widget.controller.setStoryEditingModeSelected = StoryEditingModes.text;

                        },
                        onTapOutside: (event) {
                          if (_textEditingController.text.isEmpty) {
                            widget.controller.setStoryEditingModeSelected = StoryEditingModes.none;
                            focusNode.unfocus();
                          }
                        },
                        autofocus: offset == const Offset(0, 0),
                        focusNode: focusNode,
                        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500, color: textColor.toColor())
                            .merge(selectedTextStyle).copyWith(color: textColor.toColor()),
                        controller: _textEditingController,

                        cursorColor: tealColor,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Add text",
                            hintStyle: TextStyle(fontSize: 20, color: Colors.grey)),
                      ),
                    ),
                  ),
                ),
              ),
            ),


            /// If keyboard is visible and field was focused
            /// show a [TextControlView]
            if(isKeyboardFocused && isFocusField)
            TextControlView(
              controller: widget.controller,
              onAlignChangeClickListener: () {

                setState(() {
                 if(leftPosition == 0.0) {
                   leftPosition = -150;
                   isAlignedLeft = true;
                   isAlignedRight = false;
                 } else if (leftPosition == -150) {
                   leftPosition = 150;
                   isAlignedLeft = false;
                   isAlignedRight = true;
                 } else {
                   leftPosition = 0.0;
                   isAlignedLeft = false;
                   isAlignedRight = false;
                 }
                });
              },
              icon: alignIcon(),
            ),


            /// If keyboard is visible and field was focused
            /// show sizing controls
            if (isKeyboardFocused && isFocusField)
              AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: 30,
                      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (fontSize >= 60) return;
                              setState(() {
                                fontSize += 5;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(child: Icon(Icons.text_increase, size: 25, color: Colors.white,)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (fontSize <= 15) return;
                              setState(() {
                                fontSize -= 5;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(child: Icon(Icons.text_decrease, size: 25, color: Colors.white)),
                            ),
                          ),
                        ],
                      )),
                ),
              ),

            /// If keyboard is visible and field was focused
            /// show font styling controls
            if (isKeyboardFocused && isFocusField)
              AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: fontStyles.length,
                      itemBuilder: (context, index) {
                        final singleTextStyle = fontStyles[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTextStyle = singleTextStyle;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 1.5,
                                color: selectedTextStyle == singleTextStyle ? Colors.white : Colors.transparent,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Aa",
                                style: fontStyles[index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

            /// If keyboard is visible and field was focused
            /// show color picker slider
            if (isKeyboardFocused && isFocusField)
              Positioned(
                top: 100,
                right: 28,
                child: HueColorPickerSlider(
                  onChanged: (hsvColor) {
                    setState(() {
                      textColor = hsvColor;
                    });
                  },
                ),
              ),

            // ! Horizontal color picker (deprecated)
            //   AnimatedPadding(
            //     duration: const Duration(milliseconds: 200),
            //     padding: EdgeInsets.only(
            //       bottom: MediaQuery.of(context).viewInsets.bottom,
            //     ),
            //   child:
            //
            //
            //   Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Container(
            //       height: 40,
            //       margin: const EdgeInsets.all(8),
            //       child: ListView(
            //         scrollDirection: Axis.horizontal,
            //         children: textFilterColors.map((color) {
            //
            //           return GestureDetector(
            //             onTap: () {
            //              setState(() {
            //                selectedColor = color;
            //              });
            //             },
            //             child: Container(
            //               margin: const EdgeInsets.symmetric(horizontal: 5),
            //               width: 40,
            //               height: 40,
            //               decoration: BoxDecoration(
            //                   color: color,
            //                   borderRadius: BorderRadius.circular(20),
            //                 border: Border.all(
            //                   width: 1.5,
            //                   color: selectedColor == color
            //                       ? Colors.white
            //                       : Colors.transparent,
            //                 ),
            //               ),
            //             ),
            //           );
            //         }).toList(),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );
  }

  IconData alignIcon() {
    if(isAlignedLeft == true) {
      return Icons.format_align_left;
    } else if (isAlignedRight == true) {
      return Icons.format_align_right;
    } else {
      return Icons.format_align_center;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
