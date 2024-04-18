import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/models/simple_sketecher.dart';
import 'package:flutter_story_editor/src/models/stroke.dart';
import 'package:flutter_story_editor/src/theme/style.dart';

import 'package:video_trimmer/video_trimmer.dart';

class TrimmerView extends StatefulWidget {
  final File file;
  final int pageIndex;
  final PageController pageController;
  final Function(File) onTrimCompleted;
  final bool? trimOnAdjust;
  final List<Stroke> lines;
  const TrimmerView(
      {super.key,
      required this.file,
      required this.pageIndex,
      required this.pageController,
      required this.onTrimCompleted,
      this.trimOnAdjust = false, required this.lines});

  @override
  TrimmerViewState createState() => TrimmerViewState();
}

class TrimmerViewState extends State<TrimmerView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  double _startValue = 0.0;
  double _endValue = 0.0;
  final Trimmer _trimmer = Trimmer();

  bool _isPlaying = false;
  bool _progressVisibility = false;
  Timer? _debounce;

  Future<String?> _trimVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? value;

    await _trimmer.saveTrimmedVideo(
        startValue: _startValue,
        endValue: _endValue,
        onSave: (value) {
          widget.onTrimCompleted(File(value!));
        }).then((value) {
      setState(() {
        _progressVisibility = false;
      });
    });

    return value;
  }

  void _debounceTrim() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _trimVideo();
    });
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();

    widget.pageController.addListener(() async {
      if (widget.pageController.page!.round() != widget.pageIndex &&
          _isPlaying) {
        await _trimmer.videoPlaybackControl(
            startValue: _startValue, endValue: _endValue); // Add this line
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _trimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: Container(
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoViewer(trimmer: _trimmer),
                CustomPaint(
                  painter: SimpleSketcher(widget.lines),
                  child: Container(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 80, left: 6, right: 6),
                      child: Center(
                        child: TrimViewer(
                            editorProperties: const TrimEditorProperties(
                            ),
                            areaProperties: const TrimAreaProperties(),
                            trimmer: _trimmer,
                            viewerHeight: 50.0,
                            viewerWidth: MediaQuery.of(context).size.width,
                            maxVideoLength: const Duration(seconds: 30),
                            onChangeStart: (value) => _startValue = value,
                            onChangeEnd: (value) {
                              _endValue = value;
                              widget.trimOnAdjust == true
                                  ? _debounceTrim()
                                  : null;
                            },
                            onChangePlaybackState: (value) {
                              setState(() => _isPlaying = value);
                            }),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (widget.trimOnAdjust == false)
                      Column(
                        children: [
                          Visibility(
                            visible: _progressVisibility,
                            child: const LinearProgressIndicator(
                              backgroundColor: tealColor,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _progressVisibility
                                ? null
                                : () async {
                                    _trimVideo();
                                  },
                            child: const Text("SAVE"),
                          ),
                        ],
                      )
                  ],
                ),

                TextButton(
                  child: _isPlaying
                      ? Container()
                      : const Icon(
                          Icons.play_arrow,
                          size: 80.0,
                          color: Colors.white,
                        ),
                  onPressed: () async {
                    bool playbackState = await _trimmer.videoPlaybackControl(
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

