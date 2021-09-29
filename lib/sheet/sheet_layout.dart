import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sheets/models/sheet.dart';
import 'package:flutter_sheets/models/sheet_controller.dart';
import 'package:flutter_sheets/sheet/cell_view.dart';
import 'package:flutter_sheets/sheet/sheet_view.dart';

class SheetLayout extends StatefulWidget {
  const SheetLayout(this.controller, {Key? key}) : super(key: key);

  final SheetController controller;

  @override
  State<SheetLayout> createState() => _SheetLayoutState();
}

class _SheetLayoutState extends State<SheetLayout> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSheetControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSheetControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: CustomMultiChildLayout(
        delegate: _SheetLayoutDelegate(Sheet.of(context), widget.controller),
        children: [
          for (int rowIndex = widget.controller.firstRowIndex;
              rowIndex < widget.controller.lastRowIndex;
              rowIndex++)
            for (int colIndex = widget.controller.firstColIndex;
                colIndex < widget.controller.lastColIndex;
                colIndex++)
              LayoutId(
                id: _CellId(rowIndex, colIndex),
                child: CellView(rowIndex, colIndex),
              ),
        ],
      ),
    );
  }

  void _onSheetControllerChanged() {
    setState(() {});
  }
}

class _SheetLayoutDelegate extends MultiChildLayoutDelegate {
  _SheetLayoutDelegate(this.sheet, this.controller)
      : _firstRowIndex = controller.firstRowIndex,
        _lastRowIndex = controller.lastRowIndex,
        _firstColIndex = controller.firstColIndex,
        _lastColIndex = controller.lastColIndex;

  Sheet sheet;
  SheetController controller;

  final int _firstRowIndex;
  final int _lastRowIndex;
  final int _firstColIndex;
  final int _lastColIndex;

  @override
  void performLayout(Size size) {
    double top = 0;
    for (int rowIndex = controller.firstRowIndex;
        rowIndex < controller.lastRowIndex;
        rowIndex++) {
      double left = 0;
      for (int colIndex = controller.firstColIndex;
          colIndex < controller.lastColIndex;
          colIndex++) {
        final _CellId childId = _CellId(rowIndex, colIndex);
        layoutChild(
          childId,
          BoxConstraints(
            maxWidth: sheet.widthOf(colIndex),
            maxHeight: sheet.heightOf(rowIndex),
          ),
        );
        positionChild(childId, Offset(left, top));
        left += sheet.widthOf(colIndex);
      }
      top += sheet.heightOf(rowIndex);
    }
  }

  @override
  bool shouldRelayout(covariant _SheetLayoutDelegate oldDelegate) {
    return oldDelegate._firstRowIndex != _firstRowIndex ||
        oldDelegate._lastRowIndex != _lastRowIndex ||
        oldDelegate._firstColIndex != _firstColIndex ||
        oldDelegate._lastColIndex != _lastColIndex;
  }
}

@immutable
class _CellId {
  const _CellId(this.rowIndex, this.colIndex);

  final int rowIndex;
  final int colIndex;

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    return '$rowIndex,$colIndex';
  }

  @override
  bool operator ==(Object other) {
    return other is _CellId &&
        rowIndex == other.rowIndex &&
        colIndex == other.colIndex;
  }
}
