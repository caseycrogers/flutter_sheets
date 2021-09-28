import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sheets/constants.dart';

import 'package:flutter_sheets/models/sheet.dart';
import 'package:vector_math/vector_math_64.dart' show Quad, Vector3;

class SheetView extends StatefulWidget {
  const SheetView(this._sheet, {Key? key}) : super(key: key);

  final Sheet _sheet;

  @override
  _SheetViewState createState() => _SheetViewState();
}

class _SheetViewState extends State<SheetView> {
  final TransformationController _transformationController =
      TransformationController();

  // Returns true iff the given cell is currently visible. Caches viewport
  // calculations.
  Quad? _cachedViewport;
  late int _visibleRowStart;
  late int _visibleColStart;
  late int _visibleRowEnd;
  late int _visibleColEnd;

  Sheet get _sheet => widget._sheet;

  bool _isCellVisible(int rowIndex, int colIndex, Quad viewport) {
    if (viewport != _cachedViewport) {
      final Rect aabb = _axisAlignedBoundingBox(viewport);
      _cachedViewport = viewport;
      _visibleRowStart = _sheet.rowIndexOf(aabb.top);
      _visibleColStart = _sheet.colIndexOf(aabb.left);
      _visibleRowEnd =
          (_sheet.rowIndexOf(aabb.bottom) + 1).clamp(0, _sheet.rowCount);
      _visibleColEnd =
          (_sheet.colIndexOf(aabb.right) + 1).clamp(0, _sheet.colCount);
      print('----------------------------------------');
      print('rowStart: $_visibleRowStart, rowEnd: $_visibleRowEnd');
      print('colStart: $_visibleColStart, colEnd: $_visibleColEnd');
    }
    return rowIndex >= _visibleRowStart &&
        rowIndex <= _visibleRowEnd &&
        colIndex >= _visibleColStart &&
        colIndex <= _visibleColEnd;
  }

  // Returns the axis aligned bounding box for the given Quad, which might not
  // be axis aligned.
  Rect _axisAlignedBoundingBox(Quad quad) {
    double? xMin;
    double? xMax;
    double? yMin;
    double? yMax;
    for (final Vector3 point in <Vector3>[
      quad.point0,
      quad.point1,
      quad.point2,
      quad.point3
    ]) {
      if (xMin == null || point.x < xMin) {
        xMin = point.x;
      }
      if (xMax == null || point.x > xMax) {
        xMax = point.x;
      }
      if (yMin == null || point.y < yMin) {
        yMin = point.y;
      }
      if (yMax == null || point.y > yMax) {
        yMax = point.y;
      }
    }
    return Rect.fromLTRB(xMin!, yMin!, xMax!, yMax!);
  }

  void _onChangeTransformation() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onChangeTransformation);
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onChangeTransformation);
    super.dispose();
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
                  for (int rowIndex = 0; rowIndex < _sheet.rowCount; rowIndex++)
                    TableRow(
                      children: [
                        for (int colIndex = 0;
                            colIndex < _sheet.colCount;
                            colIndex++)
                          _getCell(rowIndex, colIndex, viewport),
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

  Widget _getCell(int rowIndex, int colIndex, Quad viewport) {
    if (!_isCellVisible(rowIndex, colIndex, viewport)) {
      // This cell isn't visible, don't build it.
      return Container(height: _sheet.rowHeights[rowIndex] ?? kRowHeight);
    }
    return CellView(_sheet, rowIndex: rowIndex, colIndex: colIndex);
  }
}

class CellView extends StatelessWidget {
  const CellView(
    this._sheet, {
    Key? key,
    required this.rowIndex,
    required this.colIndex,
  }) : super(key: key);

  final Sheet _sheet;
  final int rowIndex;
  final int colIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _sheet.rowHeights[rowIndex],
      color:
          (rowIndex + colIndex) % 2 == 0 ? Colors.grey.shade200 : Colors.white,
      child: Text('$rowIndex, $colIndex'),
    );
  }
}
