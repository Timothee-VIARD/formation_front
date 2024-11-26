import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/i18n/strings.g.dart';
import 'package:formation_front/modules/common/custom_date_picker/custom_date_picker.dart';
import 'package:formation_front/modules/common/custom_text/custom_text.dart';
import 'package:formation_front/modules/common/snack_bar/custom_snack_bar.dart';
import 'package:formation_front/modules/common/tag/model/tag_model.dart';
import 'package:formation_front/modules/common/tag/tags.dart';
import 'package:formation_front/modules/common/time_input_field/time_input_field.dart';
import 'package:formation_front/modules/meetings/controllers/state.dart';
import 'package:formation_front/modules/meetings/widgets/new_meeting_dialog.dart';
import 'package:formation_front/modules/rooms/model/room_model.dart';

void main() {
  group('Common widgets tests', () {
    testWidgets('customCalendarDatePicker', (WidgetTester tester) async {
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

    group("Snackbar tests", () {
      testWidgets('customSnackBar error', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      final snackBar = SnackBarPage(
                        title: 'Test',
                        level: SnackBarLevel.error,
                      ).build(context);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: const Text('Show SnackBar'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show SnackBar'));
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.backgroundColor, Colors.red);
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('customSnackBar success', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      final snackBar = SnackBarPage(
                        title: 'Test2',
                        level: SnackBarLevel.success,
                      ).build(context);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: const Text('Show SnackBar'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show SnackBar'));
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.backgroundColor, Colors.green);
        expect(find.text('Test2'), findsOneWidget);
      });
    });

    testWidgets('customText', (WidgetTester tester) async {
      final List<String> texts = ['Hello', 'World'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomText(
              texts: texts,
            ),
          ),
        ),
      );

      expect(find.byType(CustomText), findsOneWidget);

      final textWidgets = tester.widget<Text>(find.text(texts[0]));
      expect(textWidgets.style!.fontWeight, FontWeight.normal);

      final textWidget = tester.widget<Text>(find.text(texts[1]));
      expect(textWidget.style!.fontWeight, FontWeight.bold);
    });

    testWidgets("tag", (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Tag(
              tag: TagModel(
                message: 'Test',
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Tag), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container));
      expect(
          container.decoration,
          BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blue,
          ));
      final text = tester.widget<Text>(find.text('Test'));
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets("timeInputField", (WidgetTester tester) async {
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
      final textFormField =
          tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textFormField.validator!(''), t.meetings.meeting.time_hint);
      expect(textFormField.validator!('12:00'), null);

      await tester.enterText(find.byType(TextFormField), '1200');
      await tester.pump();
      expect(find.text('12:00'), findsOneWidget);
    });
  });

  group('Meetings widgets test', () {
    final List<Room> rooms = [
      const Room(id: 1, name: 'Room 1', nbMax: 1),
      const Room(id: 2, name: 'Room 2', nbMax: 1),
    ];

    final MeetingsLoadSuccess state = MeetingsLoadSuccess([], rooms);

    loadTestApp(WidgetTester tester) async {
      return await tester.pumpWidget(
        MaterialApp(
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: Scaffold(
            body: NewMeetingDialog(
              state: state,
            ),
          ),
        ),
      );
    }

    group("Dialog test", () {
      testWidgets("dialog", (WidgetTester tester) async {
        await loadTestApp(tester);
        await tester.pump();

        expect(find.byType(NewMeetingDialog), findsOneWidget);
      });

      testWidgets("dialog close", (WidgetTester tester) async {
        await loadTestApp(tester);
        await tester.pump();

        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(find.byType(NewMeetingDialog), findsNothing);
      });

      testWidgets("dialog on desktop show date picker",
          (WidgetTester tester) async {
        await loadTestApp(tester);
        await tester.pump();

        expect(find.byType(CustomCalendarDatePicker), findsOneWidget);

        await tester.tap(find.byIcon(Icons.calendar_today));
        await tester.pump();

        expect(find.byType(CalendarDatePicker), findsOneWidget);
      });

      // testWidgets("dialog on mobile show date picker",
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
  });
}
