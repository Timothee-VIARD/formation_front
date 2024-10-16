sealed class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoadSuccess extends UsersState {
  final dynamic users;

  UsersLoadSuccess(this.users);
}

class UsersLoadError extends UsersState {}
