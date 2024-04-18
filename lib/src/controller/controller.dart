

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/const/filters.dart';
import 'package:flutter_story_editor/src/enums/story_editing_modes.dart';
import 'package:flutter_story_editor/src/models/stroke.dart';


/// A controller class for managing state in a Flutter story editing application.
///
/// This class uses `ChangeNotifier` to provide updates to listeners about changes in the editing state,
/// selected files, applied filters, and stroke data for the story being edited.
class FlutterStoryEditorController extends ChangeNotifier {
  // Notifier for the current editing mode.
  final editingModeNotifier = ValueNotifier<StoryEditingModes>(StoryEditingModes.none);

  /// Gets the currently selected editing mode.
  StoryEditingModes get editingModeSelected => editingModeNotifier.value;

  /// Sets the editing mode and notifies listeners.
  set setStoryEditingModeSelected(StoryEditingModes newStoryEditingSelectedMode) {
    editingModeNotifier.value = newStoryEditingSelectedMode;
    notifyListeners();
  }

  // Notifier for the currently selected file.
  final fileNotifier = ValueNotifier<File?>(null);

  /// Gets the currently selected file.
  File? get fileSelected => fileNotifier.value;

  /// Sets the selected file and notifies listeners.
  set setFileSelected(File? newFile) {
    fileNotifier.value = newFile;
    notifyListeners();
  }

  // Notifier for the currently applied filter.
  final filterNotifier = ValueNotifier<List<double>>(noFiler);

  /// Gets the currently applied filter.
  List<double>? get filterSelected => filterNotifier.value;

  /// Sets the applied filter and notifies listeners.
  set setFilterSelected(List<double> newFilter) {
    filterNotifier.value = newFilter;
    notifyListeners();
  }

  // Notifier for the lines editable on the UI, stored per file.
  final ValueNotifier<List<List<Stroke>>> uiEditableFileLinesNotifier = ValueNotifier<List<List<Stroke>>>([]);

  /// Gets the list of editable lines for all files.
  List<List<Stroke>> get uiEditableFileLines => uiEditableFileLinesNotifier.value;

  /// Sets the lines for a specific file index and notifies listeners.
  void setUiEditableFileLines(int index, List<Stroke> newLines) {
    uiEditableFileLinesNotifier.value[index] = newLines;
    // Ensuring a new list reference is set to trigger listeners
    uiEditableFileLinesNotifier.value = [...uiEditableFileLines];
    uiEditableFileLinesNotifier.notifyListeners();
  }

  /// Initializes editable lines for a specified number of files.
  void initializeUiEditableFileLines(int count) {
    uiEditableFileLinesNotifier.value = List.generate(count, (index) => <Stroke>[]);
    notifyListeners();
  }
}
