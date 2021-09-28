import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sheets/constants.dart';
import 'package:flutter_sheets/models/sheet.dart';
import 'package:flutter_sheets/sheet/sheet_scrollbar.dart';

class SheetHeaders extends StatefulWidget {
  const SheetHeaders(
    this._sheet, {
    Key? key,
    required this.child,
  }) : super(key: key);

  final Sheet _sheet;
  final Widget child;

  @override
  _SheetHeadersState createState() => _SheetHeadersState();
}

const double _dummyRowHeaderWidth = 50;

class _SheetHeadersState extends State<SheetHeaders> {
  Sheet get _sheet => widget._sheet;

  @override
  Widget build(BuildContext context) {
    final ScrollController horizontalController = ScrollController();
    final ScrollController verticalController = ScrollController();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    });
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          SizedBox(
            height: kPageHeaderHeight,
            child: Row(
              children: [
                const SizedBox(width: _dummyRowHeaderWidth),
                Expanded(
                  child: _ColHeaders(
                    _sheet,
                    controller: horizontalController,
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
                  width: _dummyRowHeaderWidth,
                  child: _RowHeaders(_sheet, controller: verticalController),
                ),
                Expanded(child: Container(color: Colors.grey)),
                SizedBox(
                  width: kScrollBarPaddedThickness,
                  child: SheetScrollbar(
                    scrollDirection: Axis.vertical,
                    onDrag: (pixels) {
                      final rowIndex = _sheet.rowIndexOf(pixels);
                      verticalController.jumpTo(_sheet.topEdgeOf(rowIndex));
                    },
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
                const SizedBox(width: _dummyRowHeaderWidth),
                Expanded(
                  child: SheetScrollbar(
                    scrollDirection: Axis.horizontal,
                    onDrag: (pixels) {
                      final colIndex = _sheet.colIndexOf(pixels);
                      horizontalController.jumpTo(_sheet.leftEdgeOf(colIndex));
                    },
                    length: _sheet.width,
                  ),
                ),
                const SizedBox(width: kScrollBarPaddedThickness),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ColHeaders extends StatelessWidget {
  const _ColHeaders(
    this._sheet, {
    Key? key,
    required this.controller,
  }) : super(key: key);

  final Sheet _sheet;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      scrollDirection: Axis.horizontal,
      itemCount: _sheet.colCount,
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          color: Colors.lightBlue,
          width: _sheet.widthOf(index),
          height: kPageHeaderHeight,
          child: Text(_colName(index)),
        );
      },
    );
  }
}

class _RowHeaders extends StatelessWidget {
  const _RowHeaders(
    this._sheet, {
    Key? key,
    required this.controller,
  }) : super(key: key);

  final Sheet _sheet;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: _sheet.rowCount,
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          color: Colors.lightBlue,
          height: _sheet.heightOf(index),
          child: Text(_rowName(index)),
        );
      },
    );
  }
}

String _rowName(int rowIndex) {
  return rowIndex.toString();
}

String _colName(int colIndex) {
  return _rowName(colIndex);
  if (colIndex < 26) {
    return kLetters.substring(colIndex, colIndex + 1);
  }
  return '${_colName((colIndex ~/ 26) - 1)}${_colName(colIndex % 26)}';
}
