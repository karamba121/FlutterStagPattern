import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'components/fade_in_transition_route.dart';
import 'controllers/sync_controller.dart';
import 'features/home/home_controller.dart';
import 'features/home/home_screen.dart';
import 'features/welcome/welcome_screen.dart';

Future<void> main() async {
  // Orientação do dispositivo
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  // Tela cheia
  await SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(FlutterStagPattern());
}

class FlutterStagPattern extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => SyncController()),
        Bloc((i) => HomeController(context: context)),
      ],
      child: MaterialApp(
        navigatorObservers: <NavigatorObserver>[observer],
        title: "Flutter Stag Pattern",
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen(
          analytics: analytics,
        ),
        onGenerateRoute: (RouteSettings settings) {
          //mapeamento de rotas usando uma transição animada de "FadeIn"
          switch (settings.name) {
            case '/':
              return FadeInTransitionRoute(
                widget: WelcomeScreen(
                  analytics: analytics,
                ),
              );
              break;
            case '/home':
              return FadeInTransitionRoute(
                widget: HomeScreen(
                  analytics: analytics,
                ),
              );
              break;
          }
        },
      ),
    );
  }
}
