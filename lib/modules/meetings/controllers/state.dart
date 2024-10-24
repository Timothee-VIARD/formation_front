import 'package:formation_front/modules/meetings/model/meeting_answer_model.dart';

sealed class MeetingsState {}

class MeetingsInitial extends MeetingsState {}

class MeetingsLoading extends MeetingsState {}

class MeetingsLoadSuccess extends MeetingsState {
  final List<MeetingAnswer> meetings;

  MeetingsLoadSuccess(this.meetings);
}

class MeetingsLoadError extends MeetingsState {
  final dynamic error;

  MeetingsLoadError(this.error);
}
