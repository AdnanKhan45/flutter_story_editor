# flutter_story_editor [![Pub](https://img.shields.io/pub/v/flutter_story_editor.svg)](https://pub.dev/packages/flutter_story_editor)

This package is created using style of the WhatsApp story image/video editor, with which you can edit images and videos both together. You can add texts, stickers, freehand finger drawing, apply filter, and undo. The edited images will be returned in a **onSave** call back as **List of Files**. You can then upload it to some storage or save it locally to your gallery.

>> Video editing for now only support trimming. In future more video editing features will be added.

## Features

✅  You can edit Images, and videos both together.

✅  Draggable fancy text with (custom colors, font families, and resize)

✅  Draggable stickers & emojis

✅  Apply filters to images

✅  Freehand drawing over images

✅  Trimming video frames

## Future features

🚀 Drawing painting over video frames (requires platform specific work)

🚀 More image and video editing functionality like (WhatsApp & Instagram) stories

🚀 The UI is currently like WhatsApp, but I think we should go with something unique for flutter (your contribution & ideas will be very invaluable)

🚀 improve and enhance performance and existing features.

## Package Demo

<p float="left">

  <img src="https://media.giphy.com/media/JubXlSh0KAlZjKnqRW/giphy.gif" width=200 />
  <img src="https://media.giphy.com/media/aJ0xQJf2R7hNPLSUxa/giphy.gif" width=200 />
  <img src="https://media.giphy.com/media/jt9QoLmFKfdIztRFpy/giphy.gif" width=200 />


</p>

## Installation

Add flutter_story_editor: latest_version to your **pubspec.yaml** and then import it.

```dartimport 'package:stories_editor/stories_editor.dart';```

### Android
add the following code to your `AndroidMAnifest.xml` file
   ```xml
   <activity
    android:name="com.yalantis.ucrop.UCropActivity"
    android:screenOrientation="portrait"
    android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
   ```
### iOS
add the following code to your `info.plist` file

```xml
<key>NSCameraUsageDescription</key>
<string>Used to demonstrate image picker plugin</string>
<key>NSMicrophoneUsageDescription</key>
<string>Used to capture audio for image picker plugin</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Used to demonstrate image picker plugin</string>
```
## How to use
```dart
  // Inialize controllers within the state
  FlutterStoryEditorController controller = FlutterStoryEditorController();
  final TextEditingController _captionController = TextEditingController();
  
  // TODO: create a method to pick files (videos and images) either separate or together.


    // Select files 
    selectMedia().then((value) {
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
                              // Here you go with your edited files.
                            }
                        );
                      },
                    );
                  }
                },
              );
            }, icon: const Icon(Icons.upload, size: 50,)),
          ),
```

For more information : visit example project inside `example/example.dart`.

## Screenshots

Initial view & Multiple images selected

<p float="left">

  <img src="https://i.imgur.com/plIVQiJ.jpg" width=200 />
  <img src="https://i.imgur.com/Aw91PkQ.png" width=200 />

</p>

Images & videos together & Apply filters

<p float="left">

  <img src="https://i.imgur.com/XDCMooh.jpg" width=200 />
  <img src="https://i.imgur.com/S6PlaCM.png" width=200 />

</p>

Crop, scale and rotate & Add draggable stickers

<p float="left">

  <img src="https://i.imgur.com/w7akoHi.jpg" width=200 />
  <img src="https://i.imgur.com/X3K4pFK.png" width=200 />

</p>

Add emojis & Add draggable fancy text

<p float="left">

  <img src="https://i.imgur.com/Hkm9VOF.jpg" width=200 />
  <img src="https://i.imgur.com/iByPB5R.png" width=200 />
  <img src="https://i.imgur.com/jMDUWek.png" width=200 />

</p>

Draw freehand painting over images

<p float="left">

  <img src="https://i.imgur.com/Nm3jgOa.jpg" width=200 />
  <img src="https://i.imgur.com/5qsogMC.png" width=200 />

</p>


## Must read

The initial release of `flutter_story_editor` may have small bugs, and issues. If you found some, and you're willing to contribute feel free to create issue and rasie a PR. Make sure you inform me through my [LinkedIn DM](https://www.linkedin.com/in/muhammad-adnan-23bb8821b/)  for the issues you create in both cases either or not if you want to contribute.

This package will be improved more along the time, your contribution will be very invaluable.


## Created & Maintained By

[@MuhammadAdnan](https://github.com/AdnanKhan45), LinkedIn  : [@MuhammadAdnan](https://www.linkedin.com/in/muhammad-adnan-23bb8821b/) , Instagram  : [@MuhammadAdnan](https://www.instagram.com/dev.adnankhan/).

YouTube : [@eTechViral](https://www.youtube.com/c/eTechViral)
