import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'controllers/login_cubit.dart';
import 'controllers/login_state.dart';
import 'widgets/home_view.dart';
import 'widgets/login_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
        switch (state) {
          case LoginInitial():
            return const LoginView();
          case LoginLoading():
            return const Center(child: CircularProgressIndicator());
          case LoginSuccess():
            return const NavigationHome();
          case LoginError():
            return const Center(
              child: Text("Error"),
            );
        }
      }),
    );
  }
}
