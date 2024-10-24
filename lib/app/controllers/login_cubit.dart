import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/app/model/login_model.dart';

import '../../../modules/common/snackBar/controllers/cubit.dart';
import '../controllers/login_state.dart';
import '../repository/login_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository repository;
  final NotificationCubit notificationCubit;

  LoginCubit(this.repository, this.notificationCubit) : super(LoginInitial());

  Future<void> login(Login login) async {
    try {
      emit(LoginLoading());
      final token = await repository.login(login.toJson());
      notificationCubit.showSuccess("Login successful");
      emit(LoginSuccess(login.email, token));
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
