import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  void showSuccess(String message) {
    emit(NotificationSuccess(message));
  }

  void showError(String message) {
    emit(NotificationError(message));
  }

  void clear() {
    emit(NotificationInitial());
  }
}
