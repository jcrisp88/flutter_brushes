import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_brushes/providers/brush_values_provider.dart';
import 'package:provider/provider.dart';

import 'canvas_data.dart';
import 'canvas_editor.dart';

class CanvasHost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CanvasHostState();
}

class _CanvasHostState extends State<CanvasHost> {
  ///Don't start the Canvas if brush image has not been loaded
  bool isImageLoaded = false;

  ///Counts how many points have been skipped
  int counter = 0;

  /// Skip 5 points so the path is not crowded
  int pointToSkip = 10;

  final _canvasData = CanvasData();

  ///Points were the brush will be drawn
  List<Offset> _points = [];

  void initState() {
    super.initState();
    init();
  }

  ///init to load the brush image
  init() async {
    await _canvasData.renderNewBrush();

    isImageLoaded = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final _brushesValues = context.watch<BrushValuesProvider>();

    _canvasData.brushWidth = _brushesValues.brushWidth / 3.0;
    _canvasData.brushOpacity = _brushesValues.brushOpacity;
    _canvasData.brushColor = _brushesValues.colorPicker;
    _canvasData.brushIndex = _brushesValues.indexBrush;

    /// perform a conversion from fractional value to whole numbers
    pointToSkip = (_brushesValues.inkAmount * 100).round();

    _canvasData.renderNewBrush();
  }

  /// Canvas to Image:
  /// this image has all drawn paths, so they are not redrawn every time
  Future<ui.Image> rendered(CanvasEditor painter) async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    var size = context.size!;
    painter.paint(canvas, size);
    return await recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());
  }

  @override
  Widget build(BuildContext context) {
    final _brushesValues = context.watch<BrushValuesProvider>();

    final editor = CanvasEditor(
      _canvasData,
      _points,
      _brushesValues.renderedImage,
    );

    return GestureDetector(
      onPanDown: (detailData) {
        if (!_canvasData.isRenderingNewBrush) {
          setState(() {
            _points.add(detailData.localPosition);
          });
        }
      },
      onPanUpdate: (detailData) {
        if (!_canvasData.isRenderingNewBrush) {
          //skip 5 points so the path is not crowded
          if (counter++ >= pointToSkip) {
            setState(() {
              _points.add(detailData.localPosition);
            });
            counter = 0;
          }
        }
      },
      onPanEnd: (detailData) {
        rendered(editor).then((value) {
          // Generated image with last path drawn
          _brushesValues.renderedImage = value;

          setState(() {
            // Clear points already drawn
            _points.clear();
          });
        });
      },
      child: CustomPaint(
        painter: editor,
      ),
    );
  }

  ///adds a new point were brush will be drawn
  void addPoints(Offset offset) {
    _points.add(offset);
  }

  ///clear all drawn points, as now they are rendered in the Image
  void clear() {
    _points.clear();
  }
}
