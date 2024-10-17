import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/alert/controllers/cubit.dart';
import '../repository/users_repository.dart';
import 'state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UsersRepository repository;
  final NotificationCubit notificationCubit;

  UsersCubit(this.repository, this.notificationCubit) : super(UsersInitial());

  Future<void> getUsers() async {
    try {
      emit(UsersLoading());
      final users = await repository.getUsers();
      emit(UsersLoadSuccess(users));
    } catch (e) {
      emit(UsersLoadError(e));
      notificationCubit.showError(e.toString());
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await repository.deleteUserById(id);
      notificationCubit.showSuccess('User deleted successfully');
      emit(UsersLoadSuccess(await repository.getUsers()));
    } catch (e) {
      notificationCubit.showError(e.toString());
    }
  }

  Future<void> createUser(Map<String, dynamic> user) async {
    try {
      await repository.createUser(user);
      notificationCubit.showSuccess('User created successfully');
      emit(UsersLoadSuccess(await repository.getUsers()));
    } catch (e) {
      notificationCubit.showError(e.toString());
    }
  }
}
