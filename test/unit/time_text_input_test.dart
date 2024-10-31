import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/modules/common/timeInputField/time_input_field.dart';

void main() {
  group('TimeTextInputFormatter', () {
    final formatter = TimeTextInputFormatter();

    test('formats empty input correctly', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '');
      expect(formatter.formatEditUpdate(oldValue, newValue), newValue);
    });

    test('formats valid time input correctly', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '1234');
      final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
      expect(formattedValue.text, '12:34');
    });

    test('rejects invalid characters', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '12a4');
      final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
      expect(formattedValue.text, oldValue.text);
    });

    test('rejects invalid time values', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '2560');
      final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
      expect(formattedValue.text, oldValue.text);
    });

    test('formats 3 digits time input correctly', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '321');
      final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
      expect(formattedValue.text, '03:21');
    });

    test('formats two-digit input correctly', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '25');
      final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
      expect(formattedValue.text, '0${newValue.text[0]}:${newValue.text[1]}');
    });

    test('formats four-digit input correctly', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '1234');
      final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
      expect(formattedValue.text, '12:34');
    });

    test('adds colon to two-digit input', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '12');
      final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
      expect(formattedValue.text, '12:');
    });

    test('adds colon to three-digit input', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '123');
      final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
      expect(formattedValue.text, '12:3');
    });
  });
}
