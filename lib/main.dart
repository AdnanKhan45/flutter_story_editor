import 'package:flutter/material.dart';
import 'package:flutter_story_editor/src/controller/controller.dart';
import 'package:flutter_story_editor/src/utils/utils.dart';
import 'src/views/sticker_control_views/sticker_control_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StickerControlView(
        controller: FlutterStoryEditorController(),
        onStickerClickListener: (sticker) {
          print("Sticker clicked: $sticker");
        },
      ),
    );
  }
}
