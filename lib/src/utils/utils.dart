import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_story_editor/src/theme/style.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

Future<Uint8List?> generateThumbnail(File? file) async {
  // If the thumbnail is already generated, just return.
  if (file == null) {
    return null;
  }

  // Generate the thumbnail.
  Uint8List? thumbnail;
  if (file.path.endsWith('.mp4') ||
      file.path.endsWith('.mov') ||
      file.path.endsWith('.avi')) {
    thumbnail = await VideoThumbnail.thumbnailData(
      video: file.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 15,
    );
  }

  // return thumbnail.

  return thumbnail;
}



Future<File?> convertWidgetToImage(GlobalKey key) async {
  RenderRepaintBoundary? repaintBoundary =
      key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

  if (repaintBoundary != null) {
    ui.Image boxImage = await repaintBoundary.toImage(pixelRatio: 3.0);
    ByteData? byteData =
        await boxImage.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      Uint8List uint8list = byteData.buffer.asUint8List();
      // Write the bytes to a file.
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/image${DateTime.now().millisecondsSinceEpoch}.png').create();
      await file.writeAsBytes(uint8list);

      return file;
    } else {
      return null;
    }
  } else {
    return null;
  }
}

Future<List<File>?> convertWidgetsToImages(List<GlobalKey> keys) async {
  List<File> files = [];

  for (GlobalKey key in keys) {
    RenderRepaintBoundary? repaintBoundary =
    key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (repaintBoundary != null) {
      ui.Image boxImage = await repaintBoundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await boxImage.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List uint8list = byteData.buffer.asUint8List();
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/image${DateTime.now().millisecondsSinceEpoch}.png').create();
        await file.writeAsBytes(uint8list);
        files.add(file);
      } else {
        throw Exception("ByteData is null for key: ${key.toString()}");
      }
    } else {
      throw Exception("RepaintBoundary is null for key: ${key.toString()}");
    }
  }

  return files;
}


Future<CroppedFile?> cropImage(BuildContext context,
    {required File file}) async {
  CroppedFile? croppedFile = await ImageCropper.platform.cropImage(
      sourcePath: file.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: darkGreenColor,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: tealColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Crop Image',
        ),
        WebUiSettings(
          context: context,
        ),
      ]);

  if (croppedFile != null) {
    return croppedFile;
  } else {
    return null;
  }
}

bool isVideo(File file) {
  if (file.path.endsWith('.mp4') ||
      file.path.endsWith('.mov') ||
      file.path.endsWith('.avi')) {
    return true;
  } else {
    return false;
  }
}


