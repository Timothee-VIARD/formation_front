import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formation_front/modules/common/alert/controllers/cubit.dart';
import 'package:formation_front/theme/theme.dart';

import 'app/home.dart';
import 'utils/observers/bloc_observer.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        Bloc.observer = AppBlocObserver();
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => NotificationCubit()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: TranslationProvider.of(context).flutterLocale,
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            theme: appTheme,
            home: const Home(),
            scaffoldMessengerKey: scaffoldMessengerKey,
          ),
        );
      },
    );
  }
}
