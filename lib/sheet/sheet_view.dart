import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sheets/constants.dart';

import 'package:flutter_sheets/models/sheet.dart';
import 'package:flutter_sheets/models/sheet_controller.dart';
import 'package:flutter_sheets/sheet/cell_view.dart';
import 'package:vector_math/vector_math_64.dart' show Quad;

class SheetView extends StatefulWidget {
  const SheetView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SheetController controller;

  @override
  _SheetViewState createState() => _SheetViewState();
}

class _SheetViewState extends State<SheetView> {
  final TransformationController _transformationController =
      TransformationController();

  Sheet get _sheet => Sheet.of(context);

  SheetController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return InteractiveViewer.builder(
            panEnabled: true,
            scaleEnabled: false,
            transformationController: _transformationController,
            builder: (BuildContext context, Quad viewport) {
              return Table(
                defaultColumnWidth: const FixedColumnWidth(kColWidth),
                columnWidths: _sheet.colWidths.map((index, width) {
                  return MapEntry(index, FixedColumnWidth(width));
                }),
                children: [
                  for (int rowIndex = controller.firstRowIndex;
                      rowIndex < controller.lastRowIndex;
                      rowIndex++)
                    TableRow(
                      children: [
                        for (int colIndex = 0;
                            colIndex < _sheet.colCount;
                            colIndex++)
                          CellView(
                            rowIndex,
                            colIndex,
                            key: ValueKey('$colIndex,$rowIndex'),
                          ),
                      ],
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
