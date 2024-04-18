
import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/enums/story_editing_modes.dart';

class FilterTextView extends StatefulWidget {

  StoryEditingModes showFilters = StoryEditingModes.NONE;
  final Function(StoryEditingModes) onChange;
  FilterTextView({super.key, this.showFilters = StoryEditingModes.NONE, required this.onChange});

  @override
  State<FilterTextView> createState() => _FilterTextViewState();
}

class _FilterTextViewState extends State<FilterTextView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < 0) {
          setState(() {
            widget.showFilters =
                StoryEditingModes.FILTERS; // show filters when swiped up
          });
          widget.onChange(widget.showFilters);
        } else if (details.delta.dy > 0) {
          setState(() {
            widget.showFilters =
                StoryEditingModes.FILTERS; // hide filters when swiped down
          });
          widget.onChange(widget.showFilters);
        }
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: widget.showFilters ==StoryEditingModes.FILTERS  ? 0 : 1,
        child: AnimatedContainer(
          height: widget.showFilters ==StoryEditingModes.FILTERS
              ? 100
              : 50, // change height based on showFilters
          duration: const Duration(milliseconds: 300),
          child: const Column(
            children: [
              Icon(
                Icons.keyboard_arrow_up,
                size: 25,
                color: Colors.white,
              ),
              Text(
                "Filters",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
