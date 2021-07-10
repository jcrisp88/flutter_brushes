import 'package:flutter/material.dart';
import 'package:flutter_brushes/providers/brush_values_provider.dart';
import 'package:provider/provider.dart';

class BrushType extends StatefulWidget {
  @override
  _BrushTypeState createState() => _BrushTypeState();
}

class _BrushTypeState extends State<BrushType> {
  int _brushSelected = 0;

  @override
  Widget build(BuildContext context) {
    final _brushValues = Provider.of<BrushValuesProvider>(context);

    return Expanded(
      child: Row(
        children: [
          Text('brushType'),
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey,
                child: FlatButton(
                  child: Text(
                    _brushValues.nameBrush,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    await _brushSelectorMenu(
                      context: context,
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

  Future _brushSelectorMenu({@required BuildContext context}) async {
    final _brushValues =
        Provider.of<BrushValuesProvider>(context, listen: false);

    Widget _content({
      @required int value,
      @required String name,
      @required Function(dynamic) onChanged,
    }) {
      return ListTile(
        title: Text(name),
        leading: Radio(
          value: value,
          groupValue: _brushSelected,
          onChanged: onChanged,
        ),
      );
    }

    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Brush Selector'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      _content(
                        value: 0,
                        name: 'MarkerBrush',
                        onChanged: (value) async {
                          _brushSelected = value;
                          _brushValues.nameBrush = 'MarkerBrush';
                          print('$value: ${_brushValues.nameBrush}');
                          setState(() {});
                        },
                      ),
                      _content(
                        value: 1,
                        name: 'SprayBrush',
                        onChanged: (value) async {
                          _brushSelected = value;
                          _brushValues.nameBrush = 'SprayBrush';
                          print('$value: ${_brushValues.nameBrush}');
                          setState(() {});
                        },
                      ),
                      _content(
                        value: 2,
                        name: 'CrayonBrush',
                        onChanged: (value) async {
                          _brushSelected = value;
                          _brushValues.nameBrush = 'CrayonBrush';
                          print('$value: ${_brushValues.nameBrush}');
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  FlatButton(
                    child: Text('Go it'),
                    onPressed: () async {
                      _brushValues.indexBrush = _brushSelected;
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        });
  }
}
