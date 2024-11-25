import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formation_front/modules/common/snack_bar/controllers/cubit.dart';
import 'package:formation_front/modules/common/snack_bar/controllers/state.dart';

void main() {
  group('NotificationCubit', () {
    late NotificationCubit notificationCubit;

    setUp(() {
      notificationCubit = NotificationCubit();
    });

    tearDown(() {
      notificationCubit.close();
    });

    blocTest<NotificationCubit, NotificationState>(
      'emits [NotificationSuccess, NotificationInitial] when showSuccess is called',
      build: () => notificationCubit,
      act: (cubit) => cubit.showSuccess('Success message'),
      expect: () => [
        NotificationSuccess('Success message'),
        NotificationInitial(),
      ],
    );

    blocTest<NotificationCubit, NotificationState>(
      'emits [NotificationError, NotificationInitial] when showError is called',
      build: () => notificationCubit,
      act: (cubit) => cubit.showError('Error message'),
      expect: () => [
        NotificationError('Error message'),
        NotificationInitial(),
      ],
    );
  });
}
