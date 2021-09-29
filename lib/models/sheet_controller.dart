import 'package:flutter/cupertino.dart';
import 'package:flutter_sheets/models/sheet.dart';

class SheetController extends ChangeNotifier {
  SheetController(
    this.sheet, {
    required Offset topLeft,
    required this.size,
  }) {
    _initialize(topLeft);
    sheet.addListener(_onSheetChanged);
  }

  final Sheet sheet;

  final Size size;

  late int _firstRowIndex;
  late int _lastRowIndex;
  late int _firstColIndex;
  late int _lastColIndex;

  late ScrollController horizontalScrollController;
  late ScrollController verticalScrollController;

  int get firstRowIndex => _firstRowIndex;

  int get lastRowIndex => _lastRowIndex;

  int get firstColIndex => _firstColIndex;

  int get lastColIndex => _lastColIndex;

  double get topEdge => sheet.topEdgeOf(_firstRowIndex);

  double get bottomEdge => topEdge + size.height;

  double get leftEdge => sheet.leftEdgeOf(_firstColIndex);

  double get rightEdge => leftEdge + size.width;

  void jumpToRow(int newFirst) {
    final int newLast = sheet.lastRowIndexOf(newFirst, size);
    if (newFirst != _firstRowIndex || newLast != _lastRowIndex) {
      _firstRowIndex = newFirst;
      _lastRowIndex = newLast;
      verticalScrollController.jumpTo(sheet.yOffsetOf(newFirst));
      notifyListeners();
    }
  }

  void jumpToCol(int newFirst) {
    final int newLast = sheet.lastColIndexOf(newFirst, size);
    if (newFirst != _firstColIndex || newLast != _lastColIndex) {
      _firstColIndex = newFirst;
      _lastColIndex = newLast;
      horizontalScrollController.jumpTo(sheet.xOffsetOf(newFirst));
      notifyListeners();
    }
  }

  void jumpToRowAt(double height) {
    jumpToRow(sheet.rowIndexOf(height));
  }

  void jumpToColAt(double width) {
    jumpToCol(sheet.colIndexOf(width));
  }

  @override
  void dispose() {
    super.dispose();
    sheet.removeListener(_onSheetChanged);
  }

  void _initialize(Offset topLeft) {
    _firstRowIndex = sheet.rowIndexOf(topLeft.dy);
    _lastRowIndex = sheet.rowIndexOf(topLeft.dy + size.height) + 1;
    _firstColIndex = sheet.colIndexOf(topLeft.dx);
    _lastColIndex = sheet.colIndexOf(topLeft.dx + size.width) + 1;

    horizontalScrollController = ScrollController(
      initialScrollOffset: sheet.xOffsetOf(_firstColIndex),
    );
    verticalScrollController = ScrollController(
      initialScrollOffset: sheet.yOffsetOf(_firstRowIndex),
    );
  }

  void _onSheetChanged() {
    final int newLastRow = sheet.lastRowIndexOf(_firstRowIndex, size);
    final int newLastCol = sheet.lastColIndexOf(_firstColIndex, size);
    if (newLastRow != _lastRowIndex || newLastCol != _lastColIndex) {
      _lastRowIndex = newLastRow;
      _lastColIndex = newLastCol;
      notifyListeners();
    }
  }
}
