import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  void showSuccess(String message) {
    emit(NotificationSuccess(message));
    clear();
  }

  void showError(String message) {
    emit(NotificationError(message));
    clear();
  }

  void clear() {
    emit(NotificationInitial());
  }
}
