import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:formation_front/modules/common/snack_bar/controllers/cubit.dart';
import 'package:formation_front/theme/theme.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http_io;
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'app/controllers/login_cubit.dart';
import 'app/repository/login_repository.dart';
import 'i18n/strings.g.dart';
import 'utils/observers/bloc_observer.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  http.Client client = http_io.IOClient();
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final http.Client client;
  final LoginRepository loginRepository;

  MyApp({super.key, required this.client}) : loginRepository = LoginRepository(client);

  @override
  Widget build(BuildContext context) {
    return Provider<http.Client>(
      create: (_) => client,
      child: TranslationProvider(
        child: Builder(
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
        ),
      ),
    );
  }
}
