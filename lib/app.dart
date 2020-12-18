import 'package:firechat/domain/blocs/session/session_bloc.dart';
import 'package:firechat/domain/blocs/session/session_state.dart';
import 'package:firechat/views/auth/login_page.dart';
import 'package:firechat/views/common/theme/colors.dart';
import 'package:firechat/views/home/home_page.dart';
import 'package:firechat/views/landing/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'common/configuration/logger.dart';
import 'common/configuration/injection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatelessWidget {

  final GlobalKey<NavigatorState> _navigatorKey;

  NavigatorState get _navigator => _navigatorKey.currentState;

  const App(this._navigatorKey, {Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionBloc>(create: (_) => SessionBloc(sl()))
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          title: "Firechat",
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''), // English, no country code
            const Locale('fr', ''), // French, no country code
          ],
          theme: ThemeData(
              backgroundColor: themeBackgroundColor,
              textTheme:
                  TextTheme(bodyText1: TextStyle(), bodyText2: TextStyle())
                      .apply(
                          bodyColor: themeTextColor,
                          displayColor: themeTextColor),
              primaryColor: themeFieldColor,
              accentColor: themeAccentColor),
          builder: _navigationBuilder,
          onGenerateRoute: (_) => LandingPage.route()),
    );
  }

  Widget Function(BuildContext, Widget) get _navigationBuilder =>
      (context, child) => BlocListener<SessionBloc, SessionState>(
            listener: (context, state) {
              logger.i(
                  "Auth state changed : ${state.status}, user : ${state.userId}");
              switch (state.status) {
                case SessionStatus.authenticated:
                  _navigator.pushAndRemoveUntil(
                      HomePage.route(), (route) => false);
                  break;
                case SessionStatus.unauthenticated:
                  _navigator.pushAndRemoveUntil(
                      LoginPage.route(), (route) => false);
                  break;
                default:
                  _navigator.pushAndRemoveUntil(
                      LandingPage.route(), (route) => false);
                  break;
              }
            },
            child: child,
          );
}
