import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sheets/constants.dart';
import 'package:flutter_sheets/models/sheet.dart';

import 'package:flutter_sheets/models/sheet_controller.dart';

class SheetHeader extends StatelessWidget {
  const SheetHeader({
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
    final int itemCount = isVertical ? sheet.rowCount : sheet.colCount;
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.separated(
        controller: isVertical
            ? controller.verticalScrollController
            : controller.horizontalScrollController,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: axis,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final bool isFirst = index == 0;
          final bool isLast = index == itemCount;
          return Flex(
            direction: axis,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isFirst)
                Container(
                  color: Colors.grey.shade400,
                  width: isVertical ? null : kBorderThickness / 2,
                  height: isVertical ? kBorderThickness / 2 : null,
                ),
              _HeaderCell(isVertical: isVertical, index: index),
              if (isLast)
                Container(
                  color: Colors.grey.shade400,
                  width: isVertical ? null : kBorderThickness / 2,
                  height: isVertical ? kBorderThickness / 2 : null,
                ),
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return _ResizeHandle(axis: axis, index: index);
        },
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    Key? key,
    required this.isVertical,
    required this.index,
  }) : super(key: key);

  final bool isVertical;
  final int index;

  @override
  Widget build(BuildContext context) {
    final Sheet sheet = Sheet.of(context);
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.symmetric(
          vertical: isVertical ? _side : BorderSide.none,
          horizontal: isVertical ? BorderSide.none : _side,
        ),
      ),
      width: isVertical
          ? kPageHeaderHeight + kBorderThickness
          : sheet.widthOf(index, padded: false),
      height: isVertical
          ? sheet.heightOf(index, padded: false)
          : kPageHeaderHeight + kBorderThickness,
      child: Text(isVertical ? sheet.rowName(index) : sheet.colName(index)),
    );
  }
}

class _ResizeHandle extends StatelessWidget {
  const _ResizeHandle({
    Key? key,
    required this.axis,
    required this.index,
  }) : super(key: key);

  final Axis axis;
  final int index;

  bool get isVertical => axis == Axis.vertical;

  @override
  Widget build(BuildContext context) {
    final Sheet sheet = Sheet.of(context);
    return Draggable(
      axis: axis,
      feedback: Container(
        color: Colors.blue,
        width:
            isVertical ? MediaQuery.of(context).size.width : kBorderThickness,
        height:
            isVertical ? kBorderThickness : MediaQuery.of(context).size.height,
      ),
      child: Container(
        color: Colors.grey.shade400,
        width: isVertical ? null : kBorderThickness,
        height: isVertical ? kBorderThickness : null,
      ),
      onDragEnd: (details) {
        if (isVertical) {
          final double newHeight = details.offset.dy - sheet.topEdgeOf(index);
          if (newHeight > 10) {
            sheet.setHeight(
              index,
              newHeight,
            );
          }
          return;
        }
        final double newWidth = details.offset.dx - sheet.leftEdgeOf(index);
        if (newWidth > 10) {
          sheet.setWidth(
            index,
            newWidth,
          );
        }
      },
    );
  }
}

final BorderSide _side = BorderSide(
  color: Colors.grey.shade400,
  width: kBorderThickness / 2,
);
