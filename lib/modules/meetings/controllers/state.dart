import 'package:formation_front/modules/meetings/model/meeting_answer_model.dart';

import '../../rooms/model/room_model.dart';

sealed class MeetingsState {}

class MeetingsInitial extends MeetingsState {}

class MeetingsLoading extends MeetingsState {}

class MeetingsLoadSuccess extends MeetingsState {
  final List<MeetingAnswer> meetings;
  final List<Room> rooms;

  MeetingsLoadSuccess(this.meetings, this.rooms);
}

class MeetingsLoadError extends MeetingsState {
  final Object error;

  MeetingsLoadError(this.error);
}
