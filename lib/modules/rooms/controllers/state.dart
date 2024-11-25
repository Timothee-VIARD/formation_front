import 'package:formation_front/modules/rooms/model/room_model.dart';

sealed class RoomsState {}

class RoomsInitial extends RoomsState {}

class RoomsLoading extends RoomsState {}

class RoomsLoadSuccess extends RoomsState {
  final List<Room> rooms;

  RoomsLoadSuccess(this.rooms);
}

class RoomsLoadError extends RoomsState {
  final Object error;

  RoomsLoadError(this.error);
}
