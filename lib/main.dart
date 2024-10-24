import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:formation_front/modules/common/snackBar/controllers/cubit.dart';
import 'package:formation_front/theme/theme.dart';

import 'app/app.dart';
import 'app/controllers/login_cubit.dart';
import 'app/repository/login_repository.dart';
import 'i18n/strings.g.dart';
import 'utils/observers/bloc_observer.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final LoginRepository loginRepository = LoginRepository();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        Bloc.observer = AppBlocObserver();
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => NotificationCubit()),
            BlocProvider(
              create: (context) => LoginCubit(
                loginRepository,
                BlocProvider.of<NotificationCubit>(context),
              ),
            )
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: TranslationProvider.of(context).flutterLocale,
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            theme: appTheme,
            home: const App(),
            scaffoldMessengerKey: scaffoldMessengerKey,
          ),
        );
      },
    );
  }
}
