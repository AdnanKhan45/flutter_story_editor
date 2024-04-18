// No Filter: Identity Matrix
import 'package:flutter/material.dart';

const noFiler = [
  1.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 1.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 1.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0
];

// Black & White
const blackAndWhiteFilter = [
  0.3, 0.6, 0.1, 0.0, 0.0,
  0.3, 0.6, 0.1, 0.0, 0.0,
  0.3, 0.6, 0.1, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0
];


// Pop: Increase saturation
const popFilter = [
  1.3, 0.0, 0.0, 0.0, 0.0,
  0.0, 1.3, 0.0, 0.0, 0.0,
  0.0, 0.0, 1.3, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0
];

// Cool: Add a blue tint
const coolFilter = [
  1.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 1.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 1.2, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0
];

// Chrome: Increase contrast
const chromeFilter = [
  1.5, 0.0, 0.0, 0.0, -0.2,
  0.0, 1.5, 0.0, 0.0, -0.2,
  0.0, 0.0, 1.5, 0.0, -0.2,
  0.0, 0.0, 0.0, 1.0, 0.0
];

// Film: Decrease saturation
const filmFilter = [
  0.8, 0.2, 0.2, 0.0, 0.0,
  0.2, 0.8, 0.2, 0.0, 0.0,
  0.2, 0.2, 0.8, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0
];

final List<Color> textFilterColors = [
  Colors.white,
  Colors.black,
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple, // Violet
  Colors.brown,
];

List<TextStyle> fontStyles = [
  const TextStyle(fontFamily: 'Roboto', color: Colors.white),
  const TextStyle(fontFamily: 'Merriweather', color: Colors.white),
  const TextStyle(fontFamily: 'Madimi One', fontWeight: FontWeight.bold, color: Colors.white),

  // Serif fonts (with small "tails" on letters):
  const TextStyle(fontFamily: 'Dancing Script', color: Colors.white),
  const TextStyle(fontFamily: 'Angkor', color: Colors.white),
  const TextStyle(fontFamily: 'Pacifico', color: Colors.white),

  // Sans-serif fonts (clean, without tails):
  const TextStyle(fontFamily: 'Montserrat', color: Colors.white),
  const TextStyle(fontFamily: 'Lato', color: Colors.white),

  // More stylized choices:
  const TextStyle(fontFamily: 'Oswald', color: Colors.white),
  const TextStyle(fontFamily: 'Raleway', color: Colors.white),
  const TextStyle(fontFamily: 'Lora', color: Colors.white),
];
