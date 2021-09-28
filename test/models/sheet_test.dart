import 'package:flutter_sheets/models/sheet.dart';
import 'package:test/test.dart';

void main() {
  test('Row and sheet index return correct values.', () {
    final Sheet sheet = Sheet(4, 4);
    expect(sheet.height, 4*25);
    expect(sheet.width, 4*125);

    expect(sheet.rowIndexOf(0), 0);
    expect(sheet.rowIndexOf(12), 0);
    expect(sheet.rowIndexOf(25), 1);
    expect(sheet.rowIndexOf(26), 1);
    expect(sheet.rowIndexOf(50), 2);
    expect(sheet.rowIndexOf(56), 2);
    expect(sheet.rowIndexOf(95), 3);
    expect(sheet.rowIndexOf(100), 3);
  });
}
