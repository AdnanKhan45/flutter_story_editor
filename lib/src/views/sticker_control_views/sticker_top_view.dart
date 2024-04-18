
import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/controller/controller.dart';
import 'package:flutter_story_editor/src/enums/story_editing_modes.dart';
import 'package:flutter_story_editor/src/theme/style.dart';

class StickerTopView extends StatelessWidget {
  final FlutterStoryEditorController controller;
  const StickerTopView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(onTap: () {
          controller.setStoryEditingModeSelected = StoryEditingModes.none;
        },child: const Icon(Icons.arrow_back, size: 25, color: Colors.white,)),
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: tealColor,
          ),
          child: const Center(
            child: Icon(Icons.emoji_emotions_outlined, color: Colors.white,),
          ),
        )
      ],
    );
  }
}
