import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/modules/users/controllers/cubit.dart';
import 'package:formation_front/modules/users/repository/users_repository.dart';

import '../common/alert/controllers/cubit.dart';
import 'widgets/users_view.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  final UsersRepository usersRepository = UsersRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersCubit(
        usersRepository,
        BlocProvider.of<NotificationCubit>(context),
      ),
      child: const UsersView(),
    );
  }
}