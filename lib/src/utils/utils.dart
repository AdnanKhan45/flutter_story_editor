import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_story_editor/src/theme/style.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

/// Generates a thumbnail from a video file.
///
/// [file] - The video file from which to generate the thumbnail.
///
/// Returns a [Uint8List] containing the thumbnail data, or null if the file is not a video or is null.
Future<Uint8List?> generateThumbnail(File? file) async {
  if (file == null) return null;

  Uint8List? thumbnail;
  // Supports mp4, mov, avi formats.
  if (file.path.endsWith('.mp4') || file.path.endsWith('.mov') || file.path.endsWith('.avi')) {
    thumbnail = await VideoThumbnail.thumbnailData(
      video: file.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128, // Width of the thumbnail.
      quality: 15, // Quality of the thumbnail.
    );
  }

  return thumbnail;
}

/// Converts a widget to an image file using its GlobalKey.
///
/// [key] - GlobalKey of the widget to be converted.
///
/// Returns a [File] containing the image data, or null if conversion fails.
Future<File?> convertWidgetToImage(GlobalKey key) async {
  RenderRepaintBoundary? boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

  if (boundary != null && boundary.isRepaintBoundary) {
    ui.Image boxImage = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await boxImage.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      Uint8List imageData = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/image${DateTime.now().millisecondsSinceEpoch}.png');
      await file.create();
      await file.writeAsBytes(imageData);

      return file;
    }
  }
  return null;
}

/// Converts multiple widgets to images based on their GlobalKeys.
///
/// [keys] - List of GlobalKeys for the widgets to be converted.
///
/// Returns a list of [File]s containing the image data. Throws an exception if conversion fails.
Future<List<File>?> convertWidgetsToImages(List<GlobalKey> keys) async {
  List<File> files = [];

  for (GlobalKey key in keys) {
    File? file = await convertWidgetToImage(key);
    if (file != null) files.add(file);
  }

  return files.isNotEmpty ? files : null;
}

/// Crops an image file.
///
/// [context] - Build context from which this function is invoked.
/// [file] - File to be cropped.
///
/// Returns a [CroppedFile] containing the cropped image data, or null if cropping is cancelled.
Future<CroppedFile?> cropImage(BuildContext context, {required File file}) async {
  CroppedFile? croppedFile = await ImageCropper.platform.cropImage(
      sourcePath: file.path,
      aspectRatioPresets: Platform.isAndroid
          ? [CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.original, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio16x9]
          : [CropAspectRatioPreset.original, CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio5x3, CropAspectRatioPreset.ratio5x4, CropAspectRatioPreset.ratio7x5, CropAspectRatioPreset.ratio16x9],
      uiSettings: [
        AndroidUiSettings(toolbarTitle: 'Crop Image', toolbarColor: darkGreenColor, toolbarWidgetColor: Colors.white, activeControlsWidgetColor: tealColor, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: false),
        IOSUiSettings(title: 'Crop Image'),
        WebUiSettings(context: context),
      ]);

  return croppedFile;
}

/// Determines if a file is a video.
///
/// [file] - File to be checked.
///
/// Returns [true] if the file is a video (.mp4, .mov, .avi); otherwise, returns [false].
bool isVideo(File file) {
  return file.path.endsWith('.mp4') || file.path.endsWith('.mov') || file.path.endsWith('.avi');
}
