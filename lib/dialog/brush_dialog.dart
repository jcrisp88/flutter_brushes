import 'package:collection/src/list_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_brushes/providers/brush_values_provider.dart';
import 'package:provider/src/provider.dart';

class BrushDialog extends StatefulWidget {
  final int startIndex;

  BrushDialog({required this.startIndex});

  @override
  State<StatefulWidget> createState() => _BrushDialogState();
}

class _BrushDialogState extends State<BrushDialog> {
  int _brushSelected = 0;

  @override
  void initState() {
    _brushSelected = widget.startIndex;

    super.initState();
  }

  Widget _brushTile({
    required int value,
    required String name,
    required Function(dynamic) onChanged,
  }) =>
      ListTile(
        title: Text(name),
        leading: Radio(
          value: value,
          groupValue: _brushSelected,
          onChanged: onChanged,
        ),
        onTap: () {
          onChanged(value);
        },
      );

  @override
  Widget build(BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.only(top: 16),
        title: Text('Brush Selector'),
        content: Container(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: BrushValuesProvider.brushTypes
                .mapIndexed(
                  (index, brush) => _brushTile(
                    value: index,
                    name: brush,
                    onChanged: (value) async {
                      setState(() {
                        _brushSelected = value;
                      });
                      print('$value: $brush');
                    },
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Go it'),
            onPressed: () async {
              final brushValues = context.read<BrushValuesProvider>();
              brushValues.setBrush(_brushSelected);
              Navigator.pop(context);
            },
          )
        ],
      );
}
