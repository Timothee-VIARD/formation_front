import 'package:flutter/material.dart';
import 'package:formation_front/utils/dateTime/date_state.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static DateState getDateState(DateTime date, int duration) {
    final DateTime now = DateTime.now();
    final DateTime meetingStart = date;
    final DateTime meetingEnd = date.add(Duration(minutes: duration));
    if (now.isAfter(meetingEnd)) {
      return DateState.late;
    } else if (now.isBefore(meetingStart)) {
      return DateState.soon;
    } else {
      return DateState.now;
    }
  }

  static getDateTimePlusDuration(DateTime date, int duration) {
    return date.add(Duration(minutes: duration));
  }

  static DateTime getDateTimeFromString(String date) {
    return DateTime.parse(date);
  }

  static String getDateOnly(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String getTimeOnly(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String mergeDateAndTimeString(String dataDate, String dataTime) {
    final DateTime date = DateFormat('dd/MM/yyyy').parse(dataDate);
    final TimeOfDay time =
        TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(dataTime));
    final DateTime dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);
  }
}
