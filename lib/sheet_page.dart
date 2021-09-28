import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sheets/models/sheet.dart';
import 'package:flutter_sheets/sheet/sheet_with_headers.dart';

class SheetPage extends StatefulWidget {
  const SheetPage(
    this.sheet, {
    Key? key,
  }) : super(key: key);

  final Sheet sheet;

  @override
  State<SheetPage> createState() => _SheetPageState();
}

class _SheetPageState extends State<SheetPage> {
  @override
  void initState() {
    super.initState();
    widget.sheet.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(covariant SheetPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sheet != oldWidget.sheet) {
      oldWidget.sheet.removeListener(_onChanged);
      widget.sheet.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    widget.sheet.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SheetProvider(
      widget.sheet,
      widget.sheet.updateCount,
      child: const SheetWithHeaders(),
    );
  }

  void _onChanged() {
    setState(() {});
  }
}

class SheetProvider extends InheritedWidget {
  const SheetProvider(this.sheet, this._updateCount, {required Widget child})
      : super(child: child);

  final Sheet sheet;

  // We need to cache this to see if the sheet has changed.
  final int _updateCount;

  @override
  bool updateShouldNotify(covariant SheetProvider oldWidget) {
    return _updateCount != oldWidget._updateCount;
  }
}
