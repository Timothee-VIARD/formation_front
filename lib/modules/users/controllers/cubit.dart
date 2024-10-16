import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/users_repository.dart';
import 'state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UsersRepository repository;

  UsersCubit(this.repository) : super(UsersInitial());

  Future<void> getUsers() async {
    try {
      emit(UsersLoading());
      final users = await repository.getUsers();
      emit(UsersLoadSuccess(users));
    } catch (e) {
      emit(UsersLoadError());
    }
  }
}