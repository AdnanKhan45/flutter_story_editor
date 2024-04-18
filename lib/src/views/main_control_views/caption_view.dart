import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/theme/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CaptionView extends StatelessWidget {
  final TextEditingController captionController;
  final VoidCallback onSaveClickListener;
  final FocusNode? focusNode;
  final bool isSaving;
  const CaptionView(
      {super.key,
      required this.captionController,
      required this.onSaveClickListener,
      required this.isSaving, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25), color: darkGreenColor),
          child: TextFormField(
            focusNode: focusNode,
            controller: captionController,
            style: const TextStyle(fontSize: 18),
            cursorColor: tealColor,
            decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.emoji_emotions_outlined,
                  color: Colors.white,
                  size: 28,
                ),
                hintText: "Add a caption...",
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                hintStyle: TextStyle(color: Colors.white)),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: darkGreenColor,
                ),
                child: const Row(
                  children: [
                    Icon(FontAwesomeIcons.circle, color: Colors.white,),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Status (Contacts)", style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
              GestureDetector(
                onTap: onSaveClickListener,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25), color: tealColor),
                  child: Center(
                    child: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.send_outlined,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
