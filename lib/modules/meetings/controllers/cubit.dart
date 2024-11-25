import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/modules/meetings/controllers/state.dart';
import 'package:formation_front/modules/rooms/repository/rooms_repository.dart';

import '../../common/snack_bar/controllers/cubit.dart';
import '../model/meeting_model.dart';
import '../repository/meetings_repository.dart';

class MeetingsCubit extends Cubit<MeetingsState> {
  final MeetingsRepository repository;
  final RoomsRepository roomsRepository;
  final NotificationCubit notificationCubit;

  MeetingsCubit(this.repository, this.notificationCubit, this.roomsRepository)
      : super(MeetingsInitial());

  Future<void> getMeetings() async {
    try {
      emit(MeetingsLoading());
      final meetings = await repository.getMeetings();
      final rooms = await roomsRepository.getRooms();
      emit(MeetingsLoadSuccess(meetings, rooms));
    } catch (e) {
      notificationCubit.showError(e.toString());
    }
  }

  Future<void> createMeeting(Meeting meeting, String token) async {
    try {
      emit(MeetingsLoading());
      await repository.createMeeting(meeting, token);
      final meetings = await repository.getMeetings();
      final rooms = await roomsRepository.getRooms();
      emit(MeetingsLoadSuccess(meetings, rooms));
    } catch (e) {
      notificationCubit.showError(e.toString());
    }
  }

  Future<void> deleteMeeting(int id, String token) async {
    try {
      await repository.deleteMeetingById(id, token);
      final meetings = await repository.getMeetings();
      final rooms = await roomsRepository.getRooms();
      emit(MeetingsLoadSuccess(meetings, rooms));
    } catch (e) {
      notificationCubit.showError(e.toString());
    }
  }
}
