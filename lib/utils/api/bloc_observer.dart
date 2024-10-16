import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/modules/users/controllers/state.dart';

import '../../main.dart';
import '../../modules/common/custom_snack_bar.dart';

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
    if (change.nextState is UsersLoadError) {
      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBarPage(
          title: change.nextState.error.toString(),
          level: SnackBarLevel.error,
        ).build(scaffoldMessengerKey.currentContext!),
      );
      // } else if (change.nextState is UsersLoadSuccess) {
      //   scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      //   scaffoldMessengerKey.currentState?.showSnackBar(
      //     SnackBarPage(
      //       title: 'Success',
      //       level: SnackBarLevel.success,
      //     ).build(scaffoldMessengerKey.currentContext!),
      //   );
    }
  }
}
