import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// It is responsible for notifying all widgets of the changes made to the altered values of the brush
class BrushValuesProvider with ChangeNotifier {
  /// Indicates the selected brush
  int _indexBrush = 0;

  /// Indicates the amount of ink
  double _inkAmount = 0.05;

  /// Indicate the size of the brush
  double _brushWidth = 0.3;

  /// Indicates the opacity of the brush
  double _brushOpacity = 1.0;

  /// Indicates the color of the brush
  Color _colorPicker = Color(0xff000000);

  ///it should had the background canvas image
  ///with all paths rendered as Image
  ui.Image _renderedImage;

  String _nameBrush = 'MarkerBrush';

  get renderedImage => this._renderedImage;

  set renderedImage(ui.Image renderedImage) {
    this._renderedImage = renderedImage;
    // notifyListeners();
  }

  get colorPicker => this._colorPicker;

  set colorPicker(Color colorPicker) {
    this._colorPicker = colorPicker;
    notifyListeners();
  }

  get indexBrush => this._indexBrush;

  set indexBrush(int indexBrush) {
    this._indexBrush = indexBrush;
    notifyListeners();
  }

  get inkAmount => this._inkAmount;

  set inkAmount(double inkAmount) {
    this._inkAmount = inkAmount;
    notifyListeners();
  }

  get brushWidth => this._brushWidth;

  set brushWidth(double brushWidth) {
    this._brushWidth = brushWidth;
    notifyListeners();
  }

  get brushOpacity => this._brushOpacity;

  set brushOpacity(double brushOpacity) {
    this._brushOpacity = brushOpacity;
    notifyListeners();
  }

  get nameBrush => this._nameBrush;

  set nameBrush(String nameBrush) {
    this._nameBrush = nameBrush;
    notifyListeners();
  }
}
