
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_story_editor/flutter_story_editor.dart';
import 'package:flutter_story_editor/src/controller/controller.dart';

import 'package:path/path.dart' as path;

class FlutterStoryEditorExample extends StatefulWidget {
  // final User? user;
  const FlutterStoryEditorExample({super.key});

  @override
  State<FlutterStoryEditorExample> createState() => _FlutterStoryEditorExampleState();
}

class _FlutterStoryEditorExampleState extends State<FlutterStoryEditorExample> with SingleTickerProviderStateMixin {

  FlutterStoryEditorController controller = FlutterStoryEditorController();

  final TextEditingController _captionController = TextEditingController();



  List<File>? _selectedMedia;

  List<String>? _mediaTypes; // To store the type of each selected file

  Future<void> selectMedia() async {
    setState(() {
      _selectedMedia = null;
      _mediaTypes = null;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );
      if (result != null) {
        _selectedMedia = result.files.map((file) => File(file.path!)).toList();

        // Initialize the media types list
        _mediaTypes = List<String>.filled(_selectedMedia!.length, '');

        // Determine the type of each selected file
        for (int i = 0; i < _selectedMedia!.length; i++) {
          String extension = path.extension(_selectedMedia![i].path)
              .toLowerCase();
          if (extension == '.jpg' || extension == '.jpeg' ||
              extension == '.png') {
            _mediaTypes![i] = 'image';
          } else if (extension == '.mp4' || extension == '.mov' ||
              extension == '.avi') {
            _mediaTypes![i] = 'video';
          }
        }

        setState(() {});
      } else {

      }
    } catch (e) {
      throw Exception("unable to pick files, please try again");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Center(
            child: IconButton(onPressed: () {


              selectMedia().then(
                    (value) {

                  if (_selectedMedia != null && _selectedMedia!.isNotEmpty) {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: false,
                      context: context,
                      builder: (context) {

                        return FlutterStoryEditor(
                            controller: controller,
                            captionController: _captionController,
                            selectedFiles: _selectedMedia,
                            onSaveClickListener: (files) {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ImagesPage(files: files),
                              //   ),
                              // );
                            }
                        );
                      },
                    );
                  }

                },
              );
            }, icon: const Icon(Icons.upload, size: 50,)),
          ),


          const SizedBox(height: 10),
          const Text("Pick Files & Play with them")

        ],
      ),
    );
  }
}
