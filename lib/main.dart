import 'package:flutter/material.dart';
import 'package:flutter_brushes/pages/canvas_page.dart';
import 'package:flutter_brushes/providers/brush_values_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BrushValuesProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter brushes',
        initialRoute: CanvasPage.routeName,
        routes: {
          CanvasPage.routeName: (_) => CanvasPage(),
        },
      ),
    );
  }
}
