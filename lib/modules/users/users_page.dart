import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formation_front/modules/users/controllers/cubit.dart';
import 'package:formation_front/modules/users/repository/users_repository.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../utils/mouse_back_detector.dart';
import '../common/snack_bar/controllers/cubit.dart';
import 'widgets/users_view.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        MouseBackRecognizer:
            GestureRecognizerFactoryWithHandlers<MouseBackRecognizer>(
          () => MouseBackRecognizer(),
          (instance) =>
              instance.onTapUp = (details) => handleMouseBackButton(context),
        ),
      },
      child: BlocProvider(
        create: (context) => UsersCubit(
          UsersRepository(
            Provider.of<http.Client>(context, listen: false),
          ),
          BlocProvider.of<NotificationCubit>(context),
        ),
        child: const UsersView(),
      ),
    );
  }
}
