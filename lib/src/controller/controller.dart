

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/const/filters.dart';
import 'package:flutter_story_editor/src/enums/story_editing_modes.dart';
import 'package:flutter_story_editor/src/models/stroke.dart';


class FlutterStoryEditorController extends ChangeNotifier {

  // Editing Mode
  final editingModeNotifier = ValueNotifier<StoryEditingModes>(StoryEditingModes.NONE);
  StoryEditingModes get editingModeSelected => editingModeNotifier.value;
  set setStoryEditingModeSelected(StoryEditingModes newStoryEditingSelectedMode) {
    editingModeNotifier.value = newStoryEditingSelectedMode;
    notifyListeners();
  }

  // File
  final fileNotifier = ValueNotifier<File?>(null);
  File? get fileSelected => fileNotifier.value;
  set setFileSelected(File? newFile) {
    fileNotifier.value = newFile;
    notifyListeners();
  }

  // Filter
  final filterNotifier = ValueNotifier<List<double>>(NO_FILTER);
  List<double>? get filterSelected => filterNotifier.value;
  set setFilterSelected(List<double> newFilter) {
    filterNotifier.value = newFilter;
    notifyListeners();
  }

  // uiEditableFileLines

  final ValueNotifier<List<List<Stroke>>> uiEditableFileLinesNotifier = ValueNotifier<List<List<Stroke>>>([]);

  List<List<Stroke>> get uiEditableFileLines => uiEditableFileLinesNotifier.value;

  void setUiEditableFileLines(int index, List<Stroke> newLines) {
    uiEditableFileLinesNotifier.value[index] = newLines;
    uiEditableFileLinesNotifier.value = [...uiEditableFileLines];
    uiEditableFileLinesNotifier.notifyListeners();
  }

  void initializeUiEditableFileLines(int count) {
    uiEditableFileLinesNotifier.value = List.generate(count, (index) => <Stroke>[]);
    notifyListeners();
  }

}