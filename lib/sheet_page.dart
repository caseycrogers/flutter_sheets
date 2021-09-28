import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sheets/models/sheet.dart';
import 'package:flutter_sheets/sheet/sheet_headers.dart';
import 'package:flutter_sheets/sheet/sheet_view.dart';

class SheetPage extends StatefulWidget {
  const SheetPage(this._sheet, {Key? key}) : super(key: key);

  final Sheet _sheet;

  @override
  _SheetPageState createState() => _SheetPageState();
}

class _SheetPageState extends State<SheetPage> {
  @override
  Widget build(BuildContext context) {
    return SheetHeaders(
      widget._sheet,
      child: SheetView(widget._sheet),
    );
  }
}
