import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/i18n/strings.g.dart';
import 'package:formation_front/modules/common/customDatePicker/custom_date_picker.dart';
import 'package:formation_front/modules/meetings/widgets/new_meeting_dialog.dart';
import 'package:formation_front/modules/rooms/model/room_model.dart';

void main() {
  group('NewMeetingDialog', () {
    final Future<List<Room>> rooms = Future.value([
      const Room(id: 1, name: 'Room 1', nbMax: 1),
      const Room(id: 2, name: 'Room 2', nbMax: 1),
    ]);

    loadTestApp(tester) async {
      return await tester.pumpWidget(
        MaterialApp(
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: Scaffold(
            body: NewMeetingDialog(
              rooms: rooms,
            ),
          ),
        ),
      );
    }

    testWidgets("Dialog displays correctly", (WidgetTester tester) async {
      await loadTestApp(tester);
      await tester.pump();

      expect(find.byType(NewMeetingDialog), findsOneWidget);
    });

    testWidgets("Dialog close correctly", (WidgetTester tester) async {
      await loadTestApp(tester);
      await tester.pump();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(NewMeetingDialog), findsNothing);
    });

    testWidgets("Dialog on desktop show date picker correctly",
        (WidgetTester tester) async {
      await loadTestApp(tester);
      await tester.pump();

      expect(find.byType(CustomCalendarDatePicker), findsOneWidget);

      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pump();

      expect(find.byType(CalendarDatePicker), findsOneWidget);
    });

    // testWidgets("Dialog on mobile show date picker correctly",
    //     (WidgetTester tester) async {
    //   await tester.binding.setSurfaceSize(const Size(300, 700));
    //
    //   await loadTestApp(tester);
    //   await tester.pump();
    //
    //   await tester.tap(find.byIcon(Icons.calendar_today));
    //   await tester.pumpAndSettle(const Duration(seconds: 1));
    //
    //   expect(find.byKey(const Key('DatePicker')), findsOneWidget);
    //   tester.binding.setSurfaceSize(null);
    // });
  });
}
