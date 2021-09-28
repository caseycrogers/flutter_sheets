import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sheets/constants.dart';

class SheetScrollbar extends StatefulWidget {
  const SheetScrollbar({
    required this.scrollDirection,
    required this.onDrag,
    required this.length,
    Key? key,
  }) : super(key: key);

  final Axis scrollDirection;
  final void Function(double) onDrag;
  final double length;

  @override
  State<SheetScrollbar> createState() => _SheetScrollbarState();
}

class _SheetScrollbarState extends State<SheetScrollbar> {
  late final ScrollController _controller = ScrollController()
    ..addListener(_onDrag);

  void _onDrag() {
    widget.onDrag(_controller.position.pixels);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      print(_controller.position.maxScrollExtent);
    });
    return Theme(
      data: Theme.of(context).copyWith(
          scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(Colors.grey.shade400),
      )),
      child: Scrollbar(
        controller: _controller,
        thickness: kScrollBarThickness,
        isAlwaysShown: true,
        // Garbage hack to construct a scroll bar.
        child: SingleChildScrollView(
          scrollDirection: widget.scrollDirection,
          controller: _controller,
          child: Container(
            color: Colors.grey.shade200,
            width: widget.scrollDirection == Axis.horizontal
                ? widget.length
                : kScrollBarPaddedThickness,
            height: widget.scrollDirection == Axis.vertical
                ? widget.length
                : kScrollBarPaddedThickness,
          ),
        ),
      ),
    );
  }
}
