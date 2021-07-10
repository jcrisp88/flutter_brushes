import 'package:flutter/material.dart';
import 'package:flutter_brushes/canvas/canvas_host.dart';
import 'package:flutter_brushes/widgets/menu_widget.dart';

class CanvasPage extends StatelessWidget {
  static final routeName = 'canvasPage';

  const CanvasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.maxFinite,
            width: double.maxFinite,
            child: CanvasHost(),
          ),
          MenuWidget(),
        ],
      ),
    );
  }
}
