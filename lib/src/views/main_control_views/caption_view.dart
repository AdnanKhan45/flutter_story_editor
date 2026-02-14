import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/theme/style.dart';

// CaptionView is a StatelessWidget that provides UI for entering captions and initiating save operations.
class CaptionView extends StatelessWidget {
  final TextEditingController captionController; // Controller for text input.
  final VoidCallback onSaveClickListener; // Callback function when the save button is clicked.
  final FocusNode? focusNode; // Optional focus node to manage focus behavior.
  final bool isSaving; // Boolean indicating whether a save operation is in progress.

  // Constructor initializing all fields with required annotations for mandatory fields.
  const CaptionView(
      {super.key,
      required this.captionController,
      required this.onSaveClickListener,
      required this.isSaving,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    // Building the widget structure for the caption view.
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25), // Rounded corners for aesthetic appeal.
              color: darkGreenColor), // Background color set to dark green.
          child: TextFormField(
            focusNode: focusNode, // Assigning focus node if provided.
            controller:
                captionController, // Using the provided TextEditingController for text editing.
            style: const TextStyle(fontSize: 18, color: Colors.white), // Text style customization.
            cursorColor: tealColor, // Cursor color set to teal for visual consistency.
            decoration: const InputDecoration(
                border: InputBorder.none, // No visual border for the input field.

                hintText: "Add a caption...", // Placeholder text.
                contentPadding: EdgeInsets.symmetric(
                    vertical: 15, horizontal: 15), // Padding inside the input field.
                hintStyle: TextStyle(color: Colors.white)), // Hint text style.
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Aligning children to the start and end of the row.
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // Rounded corners for the container.
                  color: darkGreenColor, // Background color set to dark green.
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      color: Colors.white,
                    ), // Icon for decorative purposes.
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Audience",
                      style: TextStyle(color: Colors.white),
                    ) // Text indicating the status.
                  ],
                ),
              ),
              GestureDetector(
                onTap:
                    onSaveClickListener, // Gesture detector to handle tap events on the save button.
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25), // Rounded corners for the button.
                      color:
                          const Color(0xFF929DB2)), // Background color set to grayLight (#929DB2).
                  child: Center(
                    child: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ) // Circular progress indicator when saving.
                        : const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ), // Icon indicating send/next action.
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
