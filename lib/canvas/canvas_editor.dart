import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'canvas_data.dart';

class CanvasEditor extends CustomPainter {
  CanvasData _canvasData;
  List<Offset> _points;

  ///drawn paths as Image
  ui.Image? _back;

  CanvasEditor(
    this._canvasData,
    this._points,
    this._back,
  );

  set canvasData(value) {
    _canvasData = value;
  }

  final Paint _paint = new Paint();

  void paint(Canvas canvas, Size size) {
    if (_back != null) {
      /// Only draw the background image if there is one
      canvas.drawImage(_back!, Offset(0, 0), _paint);
    }

    if (_points.isNotEmpty) {
      final brush = _canvasData.brushesImages[_canvasData.brushIndex]!;

      for (Offset offset in _points) {
        /// Draws the brush in every point
        Offset center = Offset(
          offset.dx - brush.width / 2,
          offset.dy - brush.height / 2,
        );

        canvas.drawImage(brush, center, _paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
