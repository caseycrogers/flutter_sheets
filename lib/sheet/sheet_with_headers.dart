import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sheets/constants.dart';
import 'package:flutter_sheets/models/sheet.dart';
import 'package:flutter_sheets/models/sheet_controller.dart';
import 'package:flutter_sheets/sheet/sheet_layout.dart';
import 'package:flutter_sheets/sheet/sheet_scrollbar.dart';

class SheetWithHeaders extends StatefulWidget {
  const SheetWithHeaders({
    Key? key,
  }) : super(key: key);

  @override
  _SheetWithHeadersState createState() => _SheetWithHeadersState();
}

const double _dummyRowHeaderWidth = 50;

class _SheetWithHeadersState extends State<SheetWithHeaders> {
  SheetController? _sheetController;

  Sheet get _sheet => Sheet.of(context);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _sheetController ??= SheetController(
        _sheet,
        topLeft: Offset.zero,
        size: Size(
          constraints.maxWidth -
              _dummyRowHeaderWidth -
              kScrollBarPaddedThickness,
          constraints.maxHeight - kPageHeaderHeight - kScrollBarPaddedThickness,
        ),
      );
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
      return Container(
        color: Colors.black,
        child: Column(
          children: [
            SizedBox(
              height: kPageHeaderHeight + kBorderThickness,
              child: Row(
                children: [
                  const SizedBox(
                    width: _dummyRowHeaderWidth + kBorderThickness,
                  ),
                  Expanded(
                    // Column Headers.
                    child: _Headers(
                      controller: _sheetController!,
                      axis: Axis.horizontal,
                    ),
                  ),
                  const SizedBox(width: kScrollBarPaddedThickness),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: _dummyRowHeaderWidth + kBorderThickness,
                    // Row headers.
                    child: _Headers(
                      controller: _sheetController!,
                      axis: Axis.vertical,
                    ),
                  ),
                  Expanded(child: SheetLayout(_sheetController!)),
                  SizedBox(
                    width: kScrollBarPaddedThickness,
                    child: SheetScrollbar(
                      controller: _sheetController!,
                      axis: Axis.vertical,
                      length: _sheet.height,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: kScrollBarPaddedThickness,
              child: Row(
                children: [
                  const SizedBox(
                    width: _dummyRowHeaderWidth + kBorderThickness,
                  ),
                  Expanded(
                    child: SheetScrollbar(
                      controller: _sheetController!,
                      axis: Axis.horizontal,
                      length: _sheet.width,
                    ),
                  ),
                  const SizedBox(
                    width: kScrollBarPaddedThickness,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

class _Headers extends StatelessWidget {
  const _Headers({
    Key? key,
    required this.controller,
    required this.axis,
  }) : super(key: key);

  final SheetController controller;
  final Axis axis;

  bool get isVertical => axis == Axis.vertical;

  @override
  Widget build(BuildContext context) {
    final Sheet sheet = Sheet.of(context);
    return ListView.builder(
      controller: isVertical
          ? controller.verticalScrollController
          : controller.horizontalScrollController,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: axis,
      itemCount: isVertical ? sheet.rowCount : sheet.colCount,
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(
              color: Colors.grey.shade400,
              width: kBorderThickness / 2,
            ),
          ),
          width: isVertical
              ? kPageHeaderHeight + kBorderThickness
              : sheet.widthOf(index),
          height: isVertical
              ? sheet.heightOf(index)
              : kPageHeaderHeight + kBorderThickness,
          child: Text(isVertical ? _rowName(index) : _colName(index)),
        );
      },
    );
  }
}

String _rowName(int rowIndex) {
  return rowIndex.toString();
}

String _colName(int colIndex) {
  if (colIndex < 26) {
    return kLetters.substring(colIndex, colIndex + 1);
  }
  return '${_colName((colIndex ~/ 26) - 1)}${_colName(colIndex % 26)}';
}
