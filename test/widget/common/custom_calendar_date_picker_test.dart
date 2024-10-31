import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/i18n/strings.g.dart';
import 'package:formation_front/modules/common/customDatePicker/custom_date_picker.dart';

void main() {
  testWidgets('CustomCalendarDatePicker', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: Scaffold(
          body: CustomCalendarDatePicker(
            controller: TextEditingController(),
          ),
        ),
      ),
    );

    expect(find.byType(CustomCalendarDatePicker), findsOneWidget);

    final DateTime now = DateTime.now();
    expect(find.text('${now.day}/${now.month}/${now.year}'), findsOneWidget);

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(find.byType(CalendarDatePicker), findsOneWidget);

    final DateTime tomorrow = now.add(const Duration(days: 1));
    final DateTime yesterday = now.subtract(const Duration(days: 1));
    final DateTime tomorrowMidnight =
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    final DateTime yesterdayMidnight =
        DateTime(yesterday.year, yesterday.month, yesterday.day);
    final DateTime selectedDate =
        (tomorrow.month != now.month) ? yesterdayMidnight : tomorrowMidnight;
    final ValueKey<DateTime> selectedDateKey = ValueKey(selectedDate);
    await tester.tap(find.byKey(selectedDateKey));
    await tester.pump();
    expect(
        find.text(
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
        findsOneWidget);
  });
}
