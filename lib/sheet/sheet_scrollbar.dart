import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sheets/constants.dart';
import 'package:flutter_sheets/models/sheet_controller.dart';

class SheetScrollbar extends StatefulWidget {
  const SheetScrollbar({
    required this.controller,
    required this.axis,
    required this.length,
    Key? key,
  }) : super(key: key);

  final SheetController controller;
  final Axis axis;
  final double length;

  @override
  State<SheetScrollbar> createState() => _SheetScrollbarState();
}

class _SheetScrollbarState extends State<SheetScrollbar> {
  late final ScrollController _scrollController = ScrollController()
    ..addListener(_onDrag);

  void _onDrag() {
    if (widget.axis == Axis.vertical) {
      return widget.controller.jumpToRowAt(_scrollController.position.pixels);
    }
    widget.controller.jumpToColAt(_scrollController.position.pixels);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(Colors.grey.shade400),
      )),
      child: Scrollbar(
        controller: _scrollController,
        thickness: kScrollBarThickness,
        isAlwaysShown: true,
        // Garbage hack to construct a scroll bar.
        child: SingleChildScrollView(
          scrollDirection: widget.axis,
          controller: _scrollController,
          child: Container(
            color: Colors.grey.shade200,
            width: widget.axis == Axis.horizontal
                ? widget.length
                : kScrollBarPaddedThickness,
            height: widget.axis == Axis.vertical
                ? widget.length
                : kScrollBarPaddedThickness,
          ),
        ),
      ),
    );
  }
}
