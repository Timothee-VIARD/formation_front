import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/i18n/strings.g.dart';
import 'package:formation_front/modules/common/time_input_field/time_input_field.dart';

void main() {
  testWidgets("TimeInputField displays correctly", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimeInputField(
            controller: TextEditingController(),
          ),
        ),
      ),
    );

    expect(find.byType(TimeInputField), findsOneWidget);
    final textFormField = tester.widget<TextFormField>(find.byType(TextFormField));
    expect(textFormField.validator!(''), t.meetings.meeting.time_hint);
    expect(textFormField.validator!('12:00'), null);

    await tester.enterText(find.byType(TextFormField), '1200');
    await tester.pump();
    expect(find.text('12:00'), findsOneWidget);
  });
}
