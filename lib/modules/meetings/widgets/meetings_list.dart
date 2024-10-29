import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:formation_front/modules/meetings/controllers/state.dart';
import 'package:formation_front/modules/meetings/model/meeting_answer_model.dart';
import 'package:formation_front/modules/meetings/widgets/meeting_card.dart';
import 'package:formation_front/modules/rooms/model/room_model.dart';

import '../../../app/controllers/login_cubit.dart';
import '../../../app/controllers/login_state.dart';
import '../../../utils/dateTime/date_time.dart';

class MeetingsList extends StatelessWidget {
  final MeetingsState state;
  final bool showPastMeetings;
  final Future<List<Room>> rooms;

  const MeetingsList(
      {super.key, required this.state, required this.showPastMeetings, required this.rooms});

  _getMeetings(String username) {
    List<MeetingAnswer> meetings =
        List.from((state as MeetingsLoadSuccess).meetings);
    meetings.sort((a, b) => a.date.compareTo(b.date));

    meetings = meetings.where((meeting) => meeting.userName == username).toList();

    if (!showPastMeetings) {
      final todayMidnight = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      meetings.removeWhere((meeting) {
        final meetingDate = DateTimeUtils.getDateTimeFromString(meeting.date);
        return meetingDate.isBefore(todayMidnight);
      });
    }
    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    LoginSuccess loginSuccess = context.read<LoginCubit>().state as LoginSuccess;
    switch (state) {
      case MeetingsLoading():
        return const Center(child: CircularProgressIndicator());
      case MeetingsLoadSuccess():
      int crossAxisCount = (MediaQuery.of(context).size.width ~/ 300).clamp(1, 5);
        return AlignedGridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          itemCount: _getMeetings(loginSuccess.username).length,
          itemBuilder: (context, index) {
            final meeting = _getMeetings(loginSuccess.username)[index];
            return MeetingCard(meeting: meeting, rooms: rooms);
          },
        );
      default:
        return Text(state.toString());
    }
  }
}
