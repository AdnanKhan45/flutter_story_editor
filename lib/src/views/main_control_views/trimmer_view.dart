import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/models/simple_sketecher.dart';
import 'package:flutter_story_editor/src/models/stroke.dart';
import 'package:flutter_story_editor/src/theme/style.dart';

import 'package:video_trimmer/video_trimmer.dart';

// TrimmerView is a StatefulWidget that provides a video trimming interface.
class TrimmerView extends StatefulWidget {
  final File file; // File to be trimmed.
  final int pageIndex; // Index of the current page in the page controller.
  final PageController pageController; // Controller for page navigation.
  final Function(File) onTrimCompleted; // Callback function after trim is completed.
  final VoidCallback? onTrimStarted; // Callback function when trim starts.
  final bool? trimOnAdjust; // If true, trims the video as adjustments are made.
  final List<Stroke> lines; // List of drawing strokes to be displayed over the video.

  // Constructor for initializing TrimmerView with required parameters.
  const TrimmerView({
    super.key,
    required this.file,
    required this.pageIndex,
    required this.pageController,
    required this.onTrimCompleted,
    this.onTrimStarted,
    this.trimOnAdjust = false,
    required this.lines,
  });

  @override
  TrimmerViewState createState() => TrimmerViewState();
}

// State class for TrimmerView, handling video loading, trimming, and UI interactions.
class TrimmerViewState extends State<TrimmerView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Ensures state is kept when swiping between tabs.

  double _startValue = 0.0; // Start position of the trim.
  double _endValue = 0.0; // End position of the trim.
  final Trimmer _trimmer = Trimmer(); // Trimmer instance for handling video operations.

  bool _isPlaying = false; // Indicates if the video is currently playing.
  bool _progressVisibility = false; // Shows or hides the progress indicator.
  Timer? _debounce; // Timer for debouncing trim operations.

  // Asynchronously trims the video and updates the UI on completion.
  Future<String?> trimVideo() async {
    if (mounted) {
      setState(() {
        _progressVisibility = true; // Show progress bar.
      });
    }
    widget.onTrimStarted?.call();

    String? value;
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String videoFileName = "trim_$timestamp";

    // Validate range before saving
    if (_endValue <= _startValue || _endValue <= 0) {
      debugPrint("StoryEditor: Invalid trim range ignored: $_startValue to $_endValue");
      if (mounted) {
        setState(() => _progressVisibility = false);
      }
      return null;
    }

    // Perform the trim operation and handle the result.
    try {
      await _trimmer
          .saveTrimmedVideo(
              startValue: _startValue,
              endValue: _endValue,
              videoFileName: videoFileName,
              onSave: (value) {
                if (mounted) {
                  widget.onTrimCompleted(File(value!)); // Callback with the new file.
                }
              })
          .then((value) {
        if (mounted) {
          setState(() {
            _progressVisibility = false; // Hide progress bar.
          });
        }
      });
    } catch (e) {
      debugPrint("StoryEditor: Error saving trimmed video: $e");
      if (mounted) {
        setState(() => _progressVisibility = false);
      }
    }

    return value;
  }

  // Debounces the trim operation to avoid excessive processing.
  void _debounceTrim() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        trimVideo();
      }
    });
  }

  // Loads the video into the trimmer.
  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();
    _loadVideo(); // Initial video load.

    // Listener to stop video playback when swiping away from the page.
    widget.pageController.addListener(() async {
      if (widget.pageController.page!.round() != widget.pageIndex && _isPlaying) {
        await _trimmer.videoPlaybackControl(startValue: _startValue, endValue: _endValue);
        if (mounted) {
          setState(() => _isPlaying = false);
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant TrimmerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.path != widget.file.path) {
      _loadVideo();
    }
  }

  @override
  void dispose() {
    _trimmer.dispose(); // Clean up the trimmer resources.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for keeping state alive.

    return Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: Container(
            color: Colors.black, // Background color.
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoViewer(trimmer: _trimmer), // Displays the video being trimmed.
                CustomPaint(
                  painter: SimpleSketcher(widget.lines), // Overlays custom sketches on the video.
                  child: Container(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    // Trim viewer and editor.
                    Container(
                      margin: const EdgeInsets.only(top: 80, left: 6, right: 6),
                      child: Center(
                        child: TrimViewer(
                            editorProperties: const TrimEditorProperties(),
                            areaProperties: const TrimAreaProperties(),
                            trimmer: _trimmer,
                            viewerHeight: 50.0,
                            viewerWidth: MediaQuery.of(context).size.width,
                            maxVideoLength: const Duration(seconds: 30),
                            onChangeStart: (value) {
                              _startValue = value;
                              widget.trimOnAdjust == true ? _debounceTrim() : null;
                            },
                            onChangeEnd: (value) {
                              _endValue = value;
                              widget.trimOnAdjust == true ? _debounceTrim() : null;
                            },
                            onChangePlaybackState: (value) {
                              setState(() => _isPlaying = value);
                            }),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Controls for manual save and progress indicator.
                    if (widget.trimOnAdjust == false)
                      Column(
                        children: [
                          Visibility(
                            visible: _progressVisibility,
                            child: const LinearProgressIndicator(
                              backgroundColor: tealColor,
                            ),
                          ),
                        ],
                      )
                  ],
                ),

                // Play button to toggle video playback.
                TextButton(
                  child: _isPlaying
                      ? Container()
                      : const Icon(
                          Icons.play_arrow,
                          size: 80.0,
                          color: Colors.white,
                        ),
                  onPressed: () async {
                    await _trimmer.videoPlaybackControl(
                      startValue: _startValue,
                      endValue: _endValue,
                    );
                    if (mounted) {
                      setState(() {
                        _isPlaying = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
