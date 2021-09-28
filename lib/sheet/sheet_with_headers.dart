import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sheets/constants.dart';
import 'package:flutter_sheets/models/sheet.dart';
import 'package:flutter_sheets/models/sheet_controller.dart';
import 'package:flutter_sheets/sheet/sheet_header.dart';
import 'package:flutter_sheets/sheet/sheet_layout.dart';
import 'package:flutter_sheets/sheet/sheet_scrollbar.dart';

class SheetWithHeaders extends StatefulWidget {
  const SheetWithHeaders({
    Key? key,
  }) : super(key: key);

  @override
  _SheetWithHeadersState createState() => _SheetWithHeadersState();
}

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
              kDummyRowHeaderWidth -
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
                    width: kDummyRowHeaderWidth + kBorderThickness,
                  ),
                  Expanded(
                    // Column Headers.
                    child: SheetHeader(
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
                    width: kDummyRowHeaderWidth + kBorderThickness,
                    // Row headers.
                    child: SheetHeader(
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
                    width: kDummyRowHeaderWidth + kBorderThickness,
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
                    height: kScrollBarPaddedThickness,
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
