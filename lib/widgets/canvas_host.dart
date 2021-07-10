import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_brushes/providers/brush_values_provider.dart';
import 'package:image/image.dart' as imagec;
import 'package:provider/provider.dart';

class CanvasHost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CanvasHostState();
  }
}

class _CanvasHostState extends State<CanvasHost> {
  ///Don't start the Canvas if brush image has not been loaded
  bool isImageloaded = false;
  GlobalKey _myCanvasKey = new GlobalKey();

  ///Counts how many points have been skiped
  int counter = 0;

  ///skip 5 points so the path is not crowded
  int pointToSkip = 10;

  void initState() {
    super.initState();
    init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _brushesValues =
        Provider.of<BrushValuesProvider>(context, listen: false);

    CanvasRelatedData.brushWidth = _brushesValues.brushWidth / 3.0;
    CanvasRelatedData.brushOpacity = _brushesValues.brushOpacity;
    CanvasRelatedData.brushColor = _brushesValues.colorPicker;
    CanvasRelatedData.brushIndex = _brushesValues.indexBrush;

    /// perform a conversion from fractional value to whole numbers
    pointToSkip =
        int.parse(((_brushesValues.inkAmount * 100).toStringAsFixed(0)));

    CanvasRelatedData.renderNewBrush();
  }

  ///init to load the brush image
  Future<Null> init() async {
    CanvasRelatedData.renderNewBrush().then((value) => isImageloaded = value);
  }

  ///Canvas to Image:
  ///this image has all drawed paths, so they are not redrawed every time
  Future<ui.Image> rendered(CanvasEditor painter) async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    var size = context.size;
    painter.paint(canvas, size);
    return await recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());
  }

  Widget _buildImage() {
    final _brushesValues = Provider.of<BrushValuesProvider>(context);

    CanvasEditor editor = CanvasEditor();
    if (_brushesValues.renderedImage != null)
      editor.background(_brushesValues.renderedImage);
    return GestureDetector(
      onPanDown: (detailData) {
        if (!CanvasRelatedData.isRenderinNewBrush) {
          editor.update(detailData.localPosition);
          _myCanvasKey.currentContext.findRenderObject().markNeedsPaint();
        }
      },
      onPanUpdate: (detailData) {
        if (!CanvasRelatedData.isRenderinNewBrush) {
          //skip 5 points so the path is not crowded
          if (counter > pointToSkip) {
            editor.update(detailData.localPosition);
            _myCanvasKey.currentContext.findRenderObject().markNeedsPaint();
            counter = 0;
          }
          counter++;
        }
      },
      onPanEnd: (detailData) {
        rendered(editor).then((value) {
          //generated imege with last path drawed
          _brushesValues.renderedImage = value;
          //Clear points already drawed
          editor.clear();
          //set the generated image as background
          if (_brushesValues.renderedImage != null)
            editor.background(_brushesValues.renderedImage);
        });
      },
      child: CustomPaint(
        key: _myCanvasKey,
        painter: editor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildImage();
  }
}

///Stores the data to be used when drawing
class CanvasRelatedData {
  ///Brush position from brushNames
  static int brushIndex = 0;
  static int lastIndex;
  //update with brush names
  static List<String> bushNames = [
    'images/marker_brush.png',
    'images/spray_brush.png',
    'images/crayon_brush.png'
  ];

  ///holds brush rendered images with actul values
  static List<ui.Image> brushesImagens = new List(bushNames.length);

  ///0 is 0% the original brush size and 1 is 100% the brush size
  static double brushWidth = 0.3;

  ///Color to be used by brush
  static Color brushColor = Color(0xff00000);

  /// brush opacity
  static double brushOpacity = 1.0;

  ///If frush image is rendering we should not draw
  static bool isRenderinNewBrush = false;
  static imagec.Image fullSizeBrushImage;

  ///Call this every time you update a value to generate
  ///a brush image with current values
  static Future<bool> renderNewBrush() async {
    //  if needed we can have a cache system here
    //  so every time a new render is needed you can
    //  check if it is already in disk, an load it
    //  instead of rendering it every time
    isRenderinNewBrush = true;
    if (lastIndex == null || brushIndex != lastIndex) {
      final ByteData data = await rootBundle.load(bushNames[brushIndex]);
      fullSizeBrushImage = imagec.decodeImage(data.buffer.asUint8List());
      lastIndex = brushIndex;
    }

    int newWidth =
        (fullSizeBrushImage.width * CanvasRelatedData.brushWidth).floor();
    int newHeight =
        (fullSizeBrushImage.height * CanvasRelatedData.brushWidth).floor();
    imagec.Image resizedBrushImage = imagec.copyResize(fullSizeBrushImage,
        height: newHeight, width: newWidth);

    var pixels = resizedBrushImage.getBytes();
    for (int i = 0, len = pixels.length; i < len; i += 4) {
      //red value from RGB
      pixels[i] = CanvasRelatedData.brushColor.red;
      //green value from RGB
      pixels[i + 1] = CanvasRelatedData.brushColor.green;
      //blue value from RGB
      pixels[i + 2] = CanvasRelatedData.brushColor.blue;
      //alpha 0=0% 1=100%
      pixels[i + 3] = (pixels[i + 3] * CanvasRelatedData.brushOpacity).floor();
    }
    ui.Codec codec =
        await ui.instantiateImageCodec(imagec.encodePng(resizedBrushImage));
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    brushesImagens[brushIndex] = frameInfo.image;
    //now than we have the brush image we can start drawing again
    isRenderinNewBrush = false;
    return true;
  }
}

class CanvasEditor extends CustomPainter {
  CanvasEditor();

  ///Points were the brush will be drawed
  List<Offset> _points = List();

  ///drawed paths as Image
  ui.Image _back;

  ///Updates the image with the last drawed path
  void background(ui.Image img) {
    _back = img;
  }

  ///adds a new point were brush will be drawed
  void update(Offset offset) {
    _points.add(offset);
  }

  ///clear all drawed points, as now they are rendered in the Image
  void clear() {
    _points.clear();
  }

  final Paint painter = new Paint();
  void paint(Canvas canvas, Size size) {
    if (_back != null) {
      ///only draw the background image if there is one
      canvas.drawImage(_back, Offset(0, 0), painter);
    }
    for (Offset offset in _points) {
      ///Draws the brush in every point
      Offset center = Offset(
          offset.dx -
              CanvasRelatedData
                      .brushesImagens[CanvasRelatedData.brushIndex].width /
                  2,
          offset.dy -
              CanvasRelatedData
                      .brushesImagens[CanvasRelatedData.brushIndex].height /
                  2);
      canvas.drawImage(
          CanvasRelatedData.brushesImagens[CanvasRelatedData.brushIndex],
          center,
          painter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
