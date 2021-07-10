import 'package:flutter/material.dart';
import 'package:flutter_brushes/providers/brush_values_provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color startColor;

  ColorPickerDialog({required this.startColor});

  @override
  State<StatefulWidget> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color? selectedColor;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: widget.startColor,
            onColorChanged: (Color color) {
              selectedColor = color;
            },
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            child: Text('Go it'),
            onPressed: () {
              final brushValues = context.read<BrushValuesProvider>();

              if (selectedColor != null) {
                brushValues.colorPicker = selectedColor!;
              }

              Navigator.pop(context);
            },
          ),
        ],
      );
}
