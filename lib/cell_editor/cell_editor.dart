import 'package:dart_pad_widget/dart_pad_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class CellEditor {
  static OverlayEntry? _currentEntry;

  static void showEditor(BuildContext context, int rowIndex, int colIndex) {
    _currentEntry?.remove();
    _currentEntry = OverlayEntry(
      builder: (innerContext) {
        return GestureDetector(
          onTap: _closeOverlay,
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black38,
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: DartPad(
                      key: ValueKey('$rowIndex,$colIndex'),
                      darkMode: false,
                      flutter: true,
                      split: true,
                      code: '''import 'package:flutter/material.dart';

void main() {
  runApp(
    Container(
      color: Colors.blue,
    ),
  );
}
''',
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                          ),
                          onPressed: _closeOverlay,
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Submit'),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(context)!.insert(_currentEntry!);
  }

  static void _closeOverlay() {
    _currentEntry!.remove();
    _currentEntry = null;
  }
}
