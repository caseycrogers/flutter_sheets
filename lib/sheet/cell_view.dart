import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sheets/cell_editor/cell_editor.dart';
import 'package:flutter_sheets/constants.dart';
import 'package:flutter_sheets/models/sheet.dart';

class CellView extends StatelessWidget {
  const CellView(
    this.rowIndex,
    this.colIndex, {
    Key? key,
  }) : super(key: key);

  final int rowIndex;
  final int colIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sheet.of(context).widthOf(colIndex),
      height: Sheet.of(context).heightOf(rowIndex),
      padding: const EdgeInsets.all(kBorderThickness / 2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade200,
          width: kBorderThickness / 2,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          CellEditor.showEditor(context, rowIndex, colIndex);
        },
      ),
    );
  }
}
