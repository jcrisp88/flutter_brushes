import 'package:flutter/material.dart';
import 'package:flutter_brushes/dialog/color_dialog.dart';
import 'package:flutter_brushes/providers/brush_values_provider.dart';
import 'package:flutter_brushes/widgets/brush_type.dart';
import 'package:provider/provider.dart';

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animHeight;
  late Animation _animWidth;

  /// Stores the menu status if it is open or closed
  bool _menuOpen = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _animWidth = Tween(begin: 0.0, end: 250.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.25)),
    );
    _animHeight = Tween(begin: 0.0, end: 250.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.25, 1.0),
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _brushValues = context.watch<BrushValuesProvider>();

    return SafeArea(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Align(
            alignment: Alignment.topRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 16.0, top: 16.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Icon(
                      Icons.settings,
                      size: 30.0,
                      color: Colors.black54,
                    ),
                    onTap: () {
                      setState(() {
                        _menuOpen = !_menuOpen;
                      });

                      if (_menuOpen)
                        _controller.forward();
                      else
                        _controller.reverse();
                    },
                  ),
                ),
                _menu(
                  context: context,
                  brushValues: _brushValues,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Function that contains the menu and all its options
  Widget _menu({
    required BuildContext context,
    required BrushValuesProvider brushValues,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 16.0),
      padding: EdgeInsets.all(8.0),
      height: _animHeight.value,
      width: _animWidth.value,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(5.0, 5.0),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Container(
        child: Column(
          children: [
            BrushType(brushValues),
            _slideItem(
              text: 'brushWidth',
              value: brushValues.brushWidth,
              numValue: (brushValues.brushWidth * 10).toStringAsFixed(0),
              min: 0.1,
              max: 0.8,
              onChanged: (value) {
                brushValues.brushWidth = value;
              },
            ),
            _brushColor(
              context: context,
              color: brushValues.colorPicker,
            ),
            _slideItem(
              text: 'brushOpacity',
              value: brushValues.brushOpacity,
              numValue:
                  (brushValues.brushOpacity * 100).toStringAsFixed(0) + "%",
              onChanged: (value) {
                setState(() {
                  brushValues.brushOpacity = value;
                });
              },
            ),
            _slideItem(
              text: 'inkAmount',
              value: brushValues.inkAmount,
              numValue: (brushValues.inkAmount * 100).toStringAsFixed(0),
              max: 0.1,
              min: 0,
              onChanged: (value) {
                setState(() {
                  brushValues.inkAmount = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Button that allows selecting the type of brush that the user wants to use

  /// Model function that handles the editable values of the brush
  Widget _slideItem({
    required String text,
    required double value,
    required Function(double) onChanged,
    required String numValue,
    double min = 0,
    double max = 1,
    // required Function(double) onChangeEnd,
  }) {
    return Expanded(
      child: Row(
        children: [
          Text(text),
          Flexible(
            child: Slider(
              // onChangeEnd: onChangeEnd,
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
          Text(numValue),
        ],
      ),
    );
  }

  /// Function that allows to open a color picker to select the color of the brush
  Widget _brushColor({
    required BuildContext context,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        children: [
          Text('brushColor'),
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: InkWell(
                child: Container(
                  color: color,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ColorPickerDialog(startColor: color),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
