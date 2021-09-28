import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sheets/models/sheet.dart';
import 'package:flutter_sheets/sheet/sheet_with_headers.dart';

class SheetPage extends StatelessWidget {
  const SheetPage(
    this.sheet, {
    Key? key,
  }): super(key: key);

  final Sheet sheet;

  @override
  Widget build(BuildContext context) {
    return SheetProvider(sheet, child: const SheetWithHeaders());
  }

}


class SheetProvider extends InheritedWidget {
  const SheetProvider(this.sheet, {required Widget child}) : super(child: child);

  final Sheet sheet;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    /// TODO: Actually make this do something.
    return false;
  }
}