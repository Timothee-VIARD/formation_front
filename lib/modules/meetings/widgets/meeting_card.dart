import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/app/controllers/login_cubit.dart';
import 'package:formation_front/app/controllers/login_state.dart';
import 'package:formation_front/app/model/token_model.dart';
import 'package:formation_front/modules/common/customText/custom_text.dart';
import 'package:formation_front/modules/common/tag/model/tag_model.dart';
import 'package:formation_front/modules/common/tag/tags.dart';
import 'package:formation_front/modules/meetings/model/meeting_answer_model.dart';
import 'package:formation_front/modules/rooms/model/room_model.dart';
import 'package:formation_front/utils/dateTime/date_state.dart';

import '../../../i18n/strings.g.dart';
import '../../../utils/dateTime/date_time.dart';
import '../controllers/cubit.dart';

class MeetingCard extends StatelessWidget {
  final MeetingAnswer meeting;
  final Future<List<Room>> rooms;

  const MeetingCard({super.key, required this.meeting, required this.rooms});

  _getDateOnly() {
    return DateTimeUtils.getDateOnly(
        DateTimeUtils.getDateTimeFromString(meeting.date));
  }

  _getTimeOnly() {
    return DateTimeUtils.getTimeOnly(
        DateTimeUtils.getDateTimeFromString(meeting.date));
  }

  _getTimeOnlyPlusDuration() {
    return DateTimeUtils.getTimeOnly(DateTimeUtils.getDateTimePlusDuration(
        DateTimeUtils.getDateTimeFromString(meeting.date), meeting.duration));
  }

  _getDateState() {
    return DateTimeUtils.getDateState(
        DateTimeUtils.getDateTimeFromString(meeting.date), meeting.duration);
  }

  _getColorState() {
    switch (_getDateState()) {
      case DateState.now:
        return const Color(0xA1ff9800);
      case DateState.soon:
        return const Color(0xA14caf50);
      case DateState.late:
        return const Color(0xB6FA6565);
    }
  }

  _getTag() {
    String message = "";
    switch (_getDateState()) {
      case DateState.now:
        message = 'En cours';
      case DateState.soon:
        message = 'A venir';
      case DateState.late:
        message = 'Terminée';
    }
    return TagModel(message: message, color: _getColorState());
  }

  _getRoomName() {
    return rooms.then((value) {
      return value.firstWhere((room) => room.id == meeting.roomId).name;
    });
  }

  _deleteMeeting(BuildContext context) {
    Token token = (context.read<LoginCubit>().state as LoginSuccess).token;
    context.read<MeetingsCubit>().deleteMeeting(meeting.id, token.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      t.meetings.data.state,
                      style: const TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const Spacer(),
                    Tag(tag: _getTag())
                  ],
                ),
                const SizedBox(height: 10),
                CustomText(texts: [t.meetings.data.title, _getDateOnly()]),
                CustomText(
                  texts: [
                    t.meetings.data.at,
                    _getTimeOnly(),
                    t.meetings.data.to,
                    _getTimeOnlyPlusDuration()
                  ],
                ),
                CustomText(
                  texts: [t.meetings.data.nbUsers, meeting.peopleNb.toString()],
                ),
                if (meeting.roomId != null)
                  FutureBuilder(
                    future: _getRoomName(),
                    builder: (context, snapshot) => snapshot.hasData
                        ? CustomText(
                            texts: [t.meetings.data.room, snapshot.data.toString()],
                          )
                        : Text(t.global.loading),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _deleteMeeting(context),
              child: Text(t.meetings.data.delete),
            ),
          ],
        ),
      ),
    );
  }
}
