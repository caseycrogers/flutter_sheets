import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sheets/models/sheet.dart';
import 'package:flutter_sheets/models/sheet_controller.dart';
import 'package:flutter_sheets/sheet/sheet_view.dart';

class SheetLayout extends StatelessWidget {
  const SheetLayout(this.controller, {Key? key}) : super(key: key);

  final SheetController controller;

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _SheetLayoutDelegate(Sheet.of(context), controller),
      children: [
        for (int rowIndex = controller.firstRowIndex;
            rowIndex <= controller.lastRowIndex;
            rowIndex++)
          for (int colIndex = controller.firstColIndex;
              colIndex <= controller.lastColIndex;
              colIndex++)
            LayoutId(
              id: _CellId(rowIndex, colIndex),
              child: CellView(rowIndex, colIndex),
            ),
      ],
    );
  }
}

class _SheetLayoutDelegate extends MultiChildLayoutDelegate {
  _SheetLayoutDelegate(this.sheet, this.controller);

  Sheet sheet;
  SheetController controller;

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
        positionChild(childId, Offset(top, left));
        left += sheet.widthOf(colIndex);
      }
      top += sheet.heightOf(rowIndex);
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    // TODO: implement shouldRelayout
    throw UnimplementedError();
  }
}

class _CellId {
  const _CellId(this.rowIndex, this.colIndex);

  final int rowIndex;
  final int colIndex;
}
