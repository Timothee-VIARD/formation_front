import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/utils/dateTime/date_state.dart';
import 'package:formation_front/utils/dateTime/date_time.dart';

void main() {
  group('DateTimeUtils', () {
    test('mergeDateAndTimeString should return correct DateTime', () {
      const date = '01/01/2022';
      const time = '12:00';
      final result = DateTimeUtils.mergeDateAndTimeString(date, time);
      expect(result, DateTime(2022, 1, 1, 12, 0));
    });

    test('getDateTimeFromString should parse date string correctly', () {
      const dateString = '2022-01-01T12:00:00';
      final result = DateTimeUtils.getDateTimeFromString(dateString);
      expect(result, DateTime(2022, 1, 1, 12, 0));
    });

    test('getDateTimePlusDuration should add duration correctly', () {
      final date = DateTime(2022, 1, 1, 12, 0);
      const duration = 60;
      final result = DateTimeUtils.getDateTimePlusDuration(date, duration);
      expect(result, DateTime(2022, 1, 1, 13, 0));
    });

    test(
        'getDateState should return DateState.late if now is after meeting end',
        () {
      final date = DateTime.now().subtract(const Duration(hours: 2));
      const duration = 60;
      final result = DateTimeUtils.getDateState(date, duration);
      expect(result, DateState.late);
    });

    test(
        'getDateState should return DateState.soon if now is before meeting start',
        () {
      final date = DateTime.now().add(const Duration(hours: 2));
      const duration = 60;
      final result = DateTimeUtils.getDateState(date, duration);
      expect(result, DateState.soon);
    });

    test(
        'getDateState should return DateState.now if now is during the meeting',
        () {
      final date = DateTime.now().subtract(const Duration(minutes: 30));
      const duration = 60;
      final result = DateTimeUtils.getDateState(date, duration);
      expect(result, DateState.now);
    });

    test('getDateOnly should return date in dd/MM/yyyy format', () {
      final date = DateTime(2022, 1, 1);
      final result = DateTimeUtils.getDateOnly(date);
      expect(result, '1/1/2022');
    });

    test('getTimeOnly should return time in HH:mm format', () {
      final date = DateTime(2022, 1, 1, 12, 0);
      final result = DateTimeUtils.getTimeOnly(date);
      expect(result, '12:00');
    });
  });
}
