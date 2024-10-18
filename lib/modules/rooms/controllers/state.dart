sealed class RoomsState {}

class RoomsInitial extends RoomsState {}

class RoomsLoading extends RoomsState {}

class RoomsLoadSuccess extends RoomsState {
  final dynamic rooms;

  RoomsLoadSuccess(this.rooms);
}

class RoomsLoadError extends RoomsState {
  final dynamic error;

  RoomsLoadError(this.error);
}
