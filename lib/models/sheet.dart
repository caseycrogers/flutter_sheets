import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_sheets/constants.dart';
import 'package:flutter_sheets/sheet_page.dart';

class Sheet {
  Sheet(
    this._rowCount,
    this._colCount, {
    this.borderWidth = 1,
    SplayTreeMap<int, double>? rowHeights,
    SplayTreeMap<int, double>? colWidths,
  })  : assert(rowHeights == null || rowHeights.length <= _rowCount),
        assert(colWidths == null || colWidths.length <= _colCount),
        assert(rowHeights == null ||
            rowHeights.keys.every((i) => i < _rowCount && i >= 0)),
        assert(colWidths == null ||
            colWidths.keys.every((i) => i < _colCount && i >= 0)),
        _rowHeights = rowHeights ?? SplayTreeMap(),
        _colWidths = colWidths ?? SplayTreeMap() {
    _initialize();
  }

  int _rowCount;
  int _colCount;
  SplayTreeMap<int, double> _rowHeights;
  SplayTreeMap<int, double> _colWidths;
  late List<double> _topEdges;
  late List<double> _leftEdges;

  void _initialize() {
    _topEdges = _sizeList(_rowHeights, kRowHeight, _rowCount);
    _leftEdges = _sizeList(_colWidths, kColWidth, _colCount);
  }

  final int borderWidth;

  int get rowCount => _rowCount;

  int get colCount => _colCount;

  Map<int, double> get rowHeights => _rowHeights;

  SplayTreeMap<int, double> get colWidths => _colWidths;

  double get width => _leftEdges.last + widthOf(_colCount - 1);

  double get height => _topEdges.last + heightOf(_rowCount - 1);

  double padding(bool padded) {
    if (padded) {
      return kBorderThickness;
    }
    return 0;
  }

  double widthOf(int colIndex, {bool padded = true}) {
    return (_colWidths[colIndex] ?? kColWidth) + padding(padded);
  }

  double heightOf(int rowIndex, {bool padded = true}) {
    return (_rowHeights[rowIndex] ?? kRowHeight) + padding(padded);
  }

  double xOffsetOf(int colIndex) {
    return _leftEdges[colIndex];
  }

  double yOffsetOf(int rowIndex) {
    return _topEdges[rowIndex];
  }

  int rowIndexOf(double height) {
    return _closestMatch(
      _topEdges,
      height,
    );
  }

  int colIndexOf(double width) {
    return _closestMatch(
      _leftEdges,
      width,
    );
  }

  /// Returns the first non-visible row.
  int lastRowIndexOf(int firstRowIndex, Size size) {
    final double viewPortBottomEdge = yOffsetOf(firstRowIndex) + size.height;
    final index = _topEdges
        .sublist(firstRowIndex)
        .indexWhere((edge) => edge >= viewPortBottomEdge);
    if (index == -1) {
      return _topEdges.length;
    }
    return firstRowIndex + index;
  }

  /// Returns the first non-visible column.
  int lastColIndexOf(int firstColIndex, Size size) {
    final double viewPortRightEdge = xOffsetOf(firstColIndex) + size.width;
    final index = _leftEdges
        .sublist(firstColIndex)
        .indexWhere((edge) => edge >= viewPortRightEdge);
    if (index == -1) {
      return _leftEdges.length;
    }
    return firstColIndex + index;
  }

  double leftEdgeOf(int colIndex) {
    return _leftEdges[colIndex];
  }

  double rightEdgeOf(int colIndex) {
    return _leftEdges[colIndex] + (_colWidths[colIndex] ?? kColWidth);
  }

  double topEdgeOf(int rowIndex) {
    return _topEdges[rowIndex];
  }

  double bottomEdgeOf(int rowIndex) {
    return _topEdges[rowIndex] + (_rowHeights[rowIndex] ?? kRowHeight);
  }

  static Sheet of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SheetProvider>()!.sheet;
  }
}

// Find the first element that is bisected by or starts at `value`.
int _closestMatch(
  List<double> cumulativeSizes,
  double value, {
  int? start,
  int? end,
}) {
  start ??= 0;
  end ??= cumulativeSizes.length;
  final int pivotIndex = ((end + start) / 2).floor();
  final double pivotValue = cumulativeSizes[pivotIndex];
  if (value == pivotValue) {
    return pivotIndex;
  }
  if (end - start == 1) {
    return start;
  }
  if (value > pivotValue) {
    return _closestMatch(cumulativeSizes, value, start: pivotIndex, end: end);
  }
  return _closestMatch(cumulativeSizes, value, start: start, end: pivotIndex);
}

List<double> _sizeList(
  Map<int, double> customSizes,
  double defaultSize,
  int length,
) {
  final List<double> sizeList = List.generate(length, (_) => -1);
  int i = 0;
  double soFar = 0;
  while (i < length) {
    sizeList[i] = soFar;
    soFar += (customSizes[i] ?? defaultSize) + kBorderThickness;
    i++;
  }
  return sizeList;
}
