
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/const/const.dart';
import 'package:flutter_story_editor/src/theme/style.dart';

// FiltersView is a StatefulWidget that displays a horizontal list of filters for users to apply to their media.
class FiltersView extends StatefulWidget {
  final List<List<double>> selectedFilters; // List holding currently selected filters for each page.
  final List<File>? selectedFiles; // Optional list of media files to apply filters on.
  final int currentPageIndex; // Index to identify the current page or media file.
  final Function(List<double>) onFilterChange; // Callback function triggered on changing a filter.

  // Constructor initializing FiltersView with necessary parameters.
  const FiltersView({
    super.key,
    required this.selectedFilters,
    this.selectedFiles,
    required this.currentPageIndex,
    required this.onFilterChange
  });

  @override
  State<FiltersView> createState() => _FiltersViewState();
}

// State class for FiltersView handling the UI and interaction.
class _FiltersViewState extends State<FiltersView> {
  @override
  Widget build(BuildContext context) {
    // Builds a scrollable horizontal list of filter options.
    return Container(
      height: 120, // Fixed height for the filter container.
      decoration: const BoxDecoration(color: darkGreenColor), // Background decoration of the filter container.
      child: ListView.builder(
        padding: const EdgeInsets.only(right: 10, left: 5),
        itemCount: Consts.filters.length, // Number of filters available from a constant source.
        scrollDirection: Axis.horizontal, // Makes the ListView scrollable horizontally.
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                widget.selectedFilters[widget.currentPageIndex] = Consts.filters[index]; // Updates the selected filter for the current page.
              });
              widget.onFilterChange(widget.selectedFilters[widget.currentPageIndex]); // Triggers the callback with the new filter selection.
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10, left: 8),
              width: 65, // Fixed width for each filter item.
              height: 100, // Fixed height for each filter item.
              child: Stack(
                children: [
                  // Displays the image with the selected filter applied.
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(Consts.filters[index]),
                      child: Image.file(
                        widget.selectedFiles![widget.currentPageIndex],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Shows a checkmark if this filter is currently selected.
                  widget.selectedFilters[widget.currentPageIndex] == Consts.filters[index]
                      ? Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1.5, color: Colors.black),
                        color: tealColor,
                      ),
                      child: const Center(
                        child: Icon(Icons.done, size: 15, color: Colors.black),
                      ),
                    ),
                  )
                      : Container(),
                  // Filter name displayed at the bottom of the filter preview.
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 70,
                      height: 25,
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
                      child: Text(
                        Consts.filterNames[index],
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
