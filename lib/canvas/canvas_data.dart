import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_brushes/providers/brush_values_provider.dart';
import 'package:image/image.dart' as imagec;

/// Stores the data to be used when drawing
class CanvasData {
  /// Brush position from brushNames
  int brushIndex = 0;
  int? lastIndex;

  // Update with brush names
  List<String> _bushNames = [
    'images/marker_brush.png',
    'images/spray_brush.png',
    'images/crayon_brush.png'
  ];

  ///holds brush rendered images with actual values
  List<ui.Image?> brushesImages = List.filled(
    BrushValuesProvider.brushTypes.length,
    null,
  );

  ///If fresh image is rendering we should not draw
  bool isRenderingNewBrush = false;
  imagec.Image? fullSizeBrushImage;

  ///0 is 0% the original brush size and 1 is 100% the brush size
  double brushWidth = 0.3;

  ///Color to be used by brush
  Color brushColor = Color(0xff00000);

  /// brush opacity
  double brushOpacity = 1.0;

  /// Call this every time you update a value to generate
  /// a brush image with current values
  Future<bool> renderNewBrush() async {
    //  if needed we can have a cache system here
    //  so every time a new render is needed you can
    //  check if it is already in disk, and load it
    //  instead of rendering it every time

    isRenderingNewBrush = true;
    if (lastIndex == null || brushIndex != lastIndex) {
      final ByteData data = await rootBundle.load(_bushNames[brushIndex]);
      fullSizeBrushImage = imagec.decodeImage(data.buffer.asUint8List());
      lastIndex = brushIndex;
    }

    int newWidth = (fullSizeBrushImage!.width * brushWidth).floor();
    int newHeight = (fullSizeBrushImage!.height * brushWidth).floor();
    imagec.Image resizedBrushImage = imagec.copyResize(fullSizeBrushImage!,
        height: newHeight, width: newWidth);

    var pixels = resizedBrushImage.getBytes();
    for (int i = 0, len = pixels.length; i < len; i += 4) {
      //red value from RGB
      pixels[i] = brushColor.red;
      //green value from RGB
      pixels[i + 1] = brushColor.green;
      //blue value from RGB
      pixels[i + 2] = brushColor.blue;
      //alpha 0=0% 1=100%
      pixels[i + 3] = (pixels[i + 3] * brushOpacity).floor();
    }
    ui.Codec codec = await ui.instantiateImageCodec(
      Uint8List.fromList(
        imagec.encodePng(resizedBrushImage),
      ),
    );
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    brushesImages[brushIndex] = frameInfo.image;
    //now than we have the brush image we can start drawing again
    isRenderingNewBrush = false;
    return true;
  }
}
