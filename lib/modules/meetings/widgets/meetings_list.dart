import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:formation_front/modules/meetings/controllers/state.dart';
import 'package:formation_front/modules/meetings/model/meeting_answer_model.dart';
import 'package:formation_front/modules/meetings/widgets/meeting_card.dart';

import '../../../utils/dateTime/date_time.dart';

class MeetingsList extends StatelessWidget {
  final MeetingsState state;
  final bool showPastMeetings;

  const MeetingsList(
      {super.key, required this.state, required this.showPastMeetings});

  _getMeetings() {
    List<MeetingAnswer> meetings =
        List.from((state as MeetingsLoadSuccess).meetings);
    meetings.sort((a, b) => a.date.compareTo(b.date));

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
    switch (state) {
      case MeetingsLoading():
        return const Center(child: CircularProgressIndicator());
      case MeetingsLoadSuccess():
        int crossAxisCount = MediaQuery.of(context).size.width ~/ 300;
        if (crossAxisCount < 1) {
          crossAxisCount = 1;
        }
        return AlignedGridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          itemCount: _getMeetings().length,
          itemBuilder: (context, index) {
            final meeting = _getMeetings()[index];
            return MeetingCard(meeting: meeting);
          },
        );
      default:
        return Text(state.toString());
    }
  }
}
