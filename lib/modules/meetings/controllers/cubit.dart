import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/modules/meetings/controllers/state.dart';

import '../../common/snackBar/controllers/cubit.dart';
import '../model/meeting_model.dart';
import '../repository/meetings_repository.dart';

class MeetingsCubit extends Cubit<MeetingsState> {
  final MeetingsRepository repository;
  final NotificationCubit notificationCubit;

  MeetingsCubit(this.repository, this.notificationCubit)
      : super(MeetingsInitial());

  Future<void> getMeetings() async {
    try {
      emit(MeetingsLoading());
      final meetings = await repository.getMeetings();
      emit(MeetingsLoadSuccess(meetings));
    } catch (e) {
      notificationCubit.showError(e.toString());
    }
  }

  Future<void> createMeeting(Meeting meeting, String token) async {
    try {
      emit(MeetingsLoading());
      await repository.createMeeting(meeting, token);
      emit(MeetingsLoadSuccess(await repository.getMeetings()));
    } catch (e) {
      notificationCubit.showError(e.toString());
    }
  }

  Future<void> deleteMeeting(int id, String token) async {
    try {
      await repository.deleteMeetingById(id, token);
      emit(MeetingsLoadSuccess(await repository.getMeetings()));
    } catch (e) {
      notificationCubit.showError(e.toString());
    }
  }
}
