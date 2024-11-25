import 'package:formation_front/modules/users/model/user_model.dart';

sealed class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoadSuccess extends UsersState {
  final List<User> users;

  UsersLoadSuccess(this.users);
}

class UsersLoadError extends UsersState {
  final Object error;

  UsersLoadError(this.error);
}
