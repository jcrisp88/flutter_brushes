import 'package:flutter/material.dart';
import 'package:flutter_brushes/dialog/brush_dialog.dart';
import 'package:flutter_brushes/providers/brush_values_provider.dart';

class BrushType extends StatelessWidget {
  final BrushValuesProvider brushValues;

  BrushType(this.brushValues);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Text('brushType'),
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey,
                child: TextButton(
                  child: Text(
                    brushValues.nameBrush,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => BrushDialog(
                        startIndex: brushValues.indexBrush,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
