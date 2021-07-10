import 'package:flutter/material.dart';
import 'package:flutter_brushes/widgets/canvas_host.dart';
import 'package:flutter_brushes/widgets/menu_widget.dart';

class CanvasPage extends StatefulWidget {
  static final routeName = 'canvasPage';

  const CanvasPage({Key key}) : super(key: key);

  @override
  _CanvasPageState createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            child: CanvasHost(),
          ),
          MenuWidget()
        ],
      ),
    );
  }
}
