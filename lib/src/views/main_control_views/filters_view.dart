
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/const/const.dart';
import 'package:flutter_story_editor/src/theme/style.dart';

class FiltersView extends StatefulWidget {

  final List<List<double>> selectedFilters;
  final List<File>? selectedFiles;
  final int currentPageIndex;
  final Function(List<double>) onFilterChange;

  const FiltersView({super.key,  required this.selectedFilters, this.selectedFiles, required this.currentPageIndex, required this.onFilterChange});

  @override
  State<FiltersView> createState() => _FiltersViewState();
}

class _FiltersViewState extends State<FiltersView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: const BoxDecoration(color: darkGreenColor),
      child: ListView.builder(
        padding: const EdgeInsets.only(right: 10, left: 5),
        itemCount: Consts.filters.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                widget.selectedFilters[widget.currentPageIndex] =
                Consts.filters[index];
              });
              widget.onFilterChange(widget.selectedFilters[widget.currentPageIndex]);
            },
            child: Container(
              margin: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 8),
              width: 65,
              height: 100,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(
                          Consts.filters[index]),
                      child: Image.file(
                        widget.selectedFiles![widget.currentPageIndex],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  widget.selectedFilters[widget.currentPageIndex] ==
                      Consts.filters[index]
                      ? Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1.5,
                            color: Colors.black),
                        color: tealColor,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.done,
                          size: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                      : Container(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 70,
                      height: 25,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.black
                              .withOpacity(.4)),
                      child: Text(
                        Consts.filterNames[index],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
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
