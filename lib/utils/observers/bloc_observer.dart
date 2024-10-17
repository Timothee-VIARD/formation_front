import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import '../../modules/common/alert/controllers/cubit.dart';
import '../../modules/common/alert/controllers/state.dart';
import '../../modules/common/alert/custom_snack_bar.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('${bloc.runtimeType} $error');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');

    if (bloc is NotificationCubit) {
      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBarPage(
          title: change.nextState.message.toString(),
          level: change.nextState is NotificationSuccess
              ? SnackBarLevel.success
              : SnackBarLevel.error,
        ).build(scaffoldMessengerKey.currentContext!),
      );
    }
  }
}
