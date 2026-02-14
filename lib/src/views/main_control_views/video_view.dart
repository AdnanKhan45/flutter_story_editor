import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/controller/controller.dart';
import 'package:flutter_story_editor/src/models/simple_sketecher.dart';
import 'package:flutter_story_editor/src/models/stroke.dart';
import 'package:flutter_story_editor/src/widgets/draggable_sticker_widget.dart';
import 'package:flutter_story_editor/src/widgets/draggable_text_widget.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final File file;
  final FlutterStoryEditorController controller;
  final List<Stroke> lines;
  final int storyIndex;
  final List<List<DraggableTextWidget>> textList;
  final List<List<DraggableStickerWidget>> stickerList;

  const VideoView({
    super.key,
    required this.file,
    required this.controller,
    required this.lines,
    required this.textList,
    required this.storyIndex,
    required this.stickerList,
  });

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.file(widget.file);
    try {
      await _videoController.initialize();
      await _videoController.setLooping(true);
      await _videoController.play();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Error initializing video: $e");
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Play/Pause indicator or interaction overlay if needed
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (_isInitialized) {
              setState(() {
                _videoController.value.isPlaying
                    ? _videoController.pause()
                    : _videoController.play();
              });
            }
          },
          child: const SizedBox.expand(),
        ),

        // Video display
        if (_isInitialized)
          IgnorePointer(
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),
          )
        else
          const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),

        // Custom painter for strokes
        IgnorePointer(
          child: CustomPaint(
            painter: SimpleSketcher(widget.lines),
            child: Container(),
          ),
        ),

        // Draggable stickers
        ...widget.stickerList[widget.storyIndex].map((sticker) => sticker),

        // Draggable text
        ...widget.textList[widget.storyIndex].map((text) => text),
      ],
    );
  }
}
