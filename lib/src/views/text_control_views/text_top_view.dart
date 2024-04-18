
import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/controller/controller.dart';
import 'package:flutter_story_editor/src/enums/story_editing_modes.dart';


class TextTopView extends StatelessWidget {
  final FlutterStoryEditorController controller;
  final VoidCallback? onAlignChangeClickListener;
  final IconData? icon;
  const TextTopView({super.key, required this.controller, this.onAlignChangeClickListener, this.icon});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();

                  controller.setStoryEditingModeSelected = StoryEditingModes.none;

                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1, color: Colors.white)
                  ),
                  child: const Center(
                    child: Text("Done", style: TextStyle(fontSize: 15, color: Colors.white),),
                  ),
                ),
              ),
              const SizedBox(width: 50),
              GestureDetector(
                onTap: () {
                  onAlignChangeClickListener!();
                },
                child: Row(
                  children: [
                    Icon(icon ?? Icons.format_align_center, size: 30, color: Colors.white,)
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
