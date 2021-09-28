import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sheets/models/sheet.dart';
import 'package:flutter_sheets/sheet_page.dart';

void main() {
  runApp(const FlutterSheets());
}

class FlutterSheets extends StatelessWidget {
  const FlutterSheets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SheetPage(Sheet(64, 32)),
      ),
    );
  }
}
