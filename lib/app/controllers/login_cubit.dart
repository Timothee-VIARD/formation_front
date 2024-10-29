import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/app/model/login_model.dart';
import 'package:formation_front/modules/users/repository/users_repository.dart';

import '../../../modules/common/snackBar/controllers/cubit.dart';
import '../controllers/login_state.dart';
import '../repository/login_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository repository;
  final NotificationCubit notificationCubit;

  LoginCubit(this.repository, this.notificationCubit) : super(LoginInitial());

  final UsersRepository usersRepository = UsersRepository();

  Future<void> login(Login login) async {
    try {
      emit(LoginLoading());
      final token = await repository.login(login.toJson());
      notificationCubit.showSuccess("Login successful");
      final users = await usersRepository.getUsers();
      final user = users.firstWhere((user) => user.email == login.email);
      emit(LoginSuccess(user.name, token));
    } catch (e) {
      await Future.delayed(const Duration(seconds: 2));
      notificationCubit.showError(e.toString());
      emit(LoginInitial());
    }
  }

  void logout() {
    emit(LoginInitial());
  }
}
