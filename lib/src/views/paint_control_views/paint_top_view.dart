import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/controller/controller.dart';
import 'package:flutter_story_editor/src/models/stroke.dart';

class PaintTopView extends StatefulWidget {
  final File selectedFile;
  final VoidCallback onUndoClickListener;
  final FlutterStoryEditorController controller;
  final HSVColor? pencilColor;
  final VoidCallback onDoneClickListener;
  final List<Stroke> lines;
  const PaintTopView(
      {super.key,
      required this.selectedFile,
      required this.onUndoClickListener,
        required this.controller,
        this.pencilColor, required this.onDoneClickListener, required this.lines,
});

  @override
  State<PaintTopView> createState() => _PaintTopViewState();
}

class _PaintTopViewState extends State<PaintTopView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: widget.onDoneClickListener,
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
              Row(
                children: [
                 widget.lines.isNotEmpty ?GestureDetector(
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
                  GestureDetector(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: widget.pencilColor!.toColor()
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 25,
                        color: Colors.white,
                      ),
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
