
import 'package:flutter/material.dart';
import 'package:hsv_color_pickers/hsv_color_pickers.dart';

class HueColorPickerSlider extends StatefulWidget {
  final Function(HSVColor) onChanged;
  const HueColorPickerSlider({super.key, required this.onChanged});

  @override
  State<HueColorPickerSlider> createState() => _HueColorPickerSliderState();
}

class _HueColorPickerSliderState extends State<HueColorPickerSlider> {
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: HuePicker(
        trackHeight: 10,
        controller: HueController(HSVColor.fromColor(Colors.tealAccent)),
        onChanged: (HSVColor color) {
          widget.onChanged(color);
        },
      ),
    );
  }
}
