import 'package:flutter/material.dart';
import 'package:flutter_brushes_app/providers/brush_values_provider.dart';
import 'package:flutter_brushes_app/widgets/brush_type.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animHeght;
  Animation _animWidth;

  /// Stores the menu status if it is open or closed
  bool _menuOpen = false;

  double _brushWidth;
  double _brushOpacity;
  double _inkAmount;
  Color _brushColorPicker;

  @override
  void didChangeDependencies() {
    final _brushValues = Provider.of<BrushValuesProvider>(context, listen: false);

    _brushWidth = _brushValues.brushWidth;
    _brushOpacity = _brushValues.brushOpacity;
    _inkAmount = _brushValues.inkAmount;
    _brushColorPicker = _brushValues.colorPicker;

    super.didChangeDependencies();
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _animWidth = Tween(begin: 0.0, end: 250.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.25)),
    );
    _animHeght = Tween(begin: 0.0, end: 250.0).animate(
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
                      if (!_menuOpen) {
                        _menuOpen = true;
                        _controller.forward();
                      } else if (_menuOpen) {
                        _controller.reverse();
                        _menuOpen = false;
                      }
                      setState(() {});
                    },
                  ),
                ),
                _menu(context: context),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Function that contains the menu and all its options
  Widget _menu({BuildContext context}) {
    final _brushValues = Provider.of<BrushValuesProvider>(context, listen: false);

    return Container(
      margin: EdgeInsets.only(right: 16.0),
      padding: EdgeInsets.all(8.0),
      height: _animHeght.value,
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
            BrushType(),
            _slideItem(
                text: 'brushWidth',
                value: _brushWidth,
                numValue: _brushWidth.toStringAsFixed(1),
                onChanged: (value) {
                  _brushWidth = value;
                  setState(() {});
                },
                onChangeEnd: (value) {
                  _brushValues.brushWidth = value;
                  setState(() {});
                }),
            _brushColor(
              context: context,
              color: _brushColorPicker,
            ),
            _slideItem(
                text: 'brushOpacity',
                value: _brushOpacity,
                numValue: _brushOpacity.toStringAsFixed(1),
                onChanged: (value) {
                  _brushOpacity = value;
                  setState(() {});
                },
                onChangeEnd: (value) {
                  _brushValues.brushOpacity = value;
                  setState(() {});
                }),
            _slideItem(
                text: 'inkAmount',
                value: _inkAmount,
                numValue: (_inkAmount * 100).toStringAsFixed(0),
                onChanged: (value) {
                  _inkAmount = value;
                  setState(() {});
                },
                onChangeEnd: (value) {
                  _brushValues.inkAmount = value;
                  setState(() {});
                }),
          ],
        ),
      ),
    );
  }

  /// Button that allows selecting the type of brush that the user wants to use

  /// Model function that handles the editable values of the brush
  Widget _slideItem({
    @required String text,
    @required double value,
    @required Function(double) onChanged,
    @required String numValue,
    @required Function(double) onChangeEnd,
  }) {
    return Expanded(
      child: Row(
        children: [
          Text(text),
          Flexible(
            child: Slider(
              onChangeEnd: onChangeEnd,
              value: value,
              onChanged: onChanged,
            ),
          ),
          Text(numValue),
        ],
      ),
    );
  }

  /// Function that allows to open a color picker to select the color of the brush
  Widget _brushColor({BuildContext context, @required Color color}) {
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
                  _colorPicker(context: context, colorSelect: color);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Function that contains the alert dialog that allows the user to change the color of the brush
  Future _colorPicker({BuildContext context, @required Color colorSelect}) async {
    Color _colorSelected;

    return await showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: colorSelect,
            onColorChanged: (Color color) {
              _colorSelected = color;
              setState(() {});
            },
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          FlatButton(
            child: Text('Go it'),
            onPressed: () {
              final _brushValues = Provider.of<BrushValuesProvider>(context, listen: false);

              if (_colorSelected != null) {
                setState(() {
                  _brushColorPicker = _colorSelected;
                  _brushValues.colorPicker = _colorSelected;
                });
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
