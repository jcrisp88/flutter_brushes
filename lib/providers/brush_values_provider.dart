import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// It is responsible for notifying all widgets of the changes made to the altered values of the brush
class BrushValuesProvider with ChangeNotifier {
  ///it should had the background canvas image
  ///with all paths rendered as Image
  ui.Image? _renderedImage;

  ui.Image? get renderedImage => this._renderedImage;

  set renderedImage(ui.Image? renderedImage) {
    this._renderedImage = renderedImage;
    // notifyListeners();
  }

  /// Indicates the color of the brush
  Color _colorPicker = Color(0xff000000);

  Color get colorPicker => this._colorPicker;

  set colorPicker(Color colorPicker) {
    this._colorPicker = colorPicker;
    notifyListeners();
  }

  /// Indicates the selected brush
  int _indexBrush = 0;

  int get indexBrush => this._indexBrush;

  String _nameBrush = brushTypes[0];

  String get nameBrush => this._nameBrush;

  setBrush(
      int index,
      ) {
    this._indexBrush = index;
    this._nameBrush = brushTypes[index];
    notifyListeners();
  }

  /// Indicates the amount of ink
  double _inkAmount = 0.00;

  double get inkAmount => this._inkAmount;

  set inkAmount(double inkAmount) {
    this._inkAmount = inkAmount;
    notifyListeners();
  }

  /// Indicate the size of the brush
  double _brushWidth = 0.3;

  double get brushWidth => this._brushWidth;

  set brushWidth(double brushWidth) {
    this._brushWidth = brushWidth;
    notifyListeners();
  }

  /// Indicates the opacity of the brush
  double _brushOpacity = 1.0;

  double get brushOpacity => this._brushOpacity;

  set brushOpacity(double brushOpacity) {
    this._brushOpacity = brushOpacity;
    notifyListeners();
  }

  static final brushTypes = [
    'MarkerBrush',
    'SprayBrush',
    'CrayonBrush',
  ];
}
