import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/modules/rooms/repository/rooms_repository.dart';

import '../../common/alert/controllers/cubit.dart';
import 'state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  final RoomsRepository repository;
  final NotificationCubit notificationCubit;

  RoomsCubit(this.repository, this.notificationCubit) : super(RoomsInitial());

  Future<void> getRooms() async {
    try {
      emit(RoomsLoading());
      final rooms = await repository.getRooms();
      emit(RoomsLoadSuccess(rooms));
    } catch (e) {
      emit(RoomsLoadError(e));
      notificationCubit.showError(e.toString());
    }
  }

  Future<void> deleteRoom(int id) async {
    try {
      await repository.deleteRoomById(id);
      notificationCubit.showSuccess('Room deleted successfully');
      emit(RoomsLoadSuccess(await repository.getRooms()));
    } catch (e) {
      notificationCubit.showError(e.toString());
    }
  }

  Future<void> createRoom(Map<String, dynamic> room) async {
    try {
      await repository.createRoom(room);
      notificationCubit.showSuccess('Room created successfully');
      emit(RoomsLoadSuccess(await repository.getRooms()));
    } catch (e) {
      notificationCubit.showError(e.toString());
    }
  }
}
