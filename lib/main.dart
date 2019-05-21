import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/fade_in_transition_route.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Stag Pattern",
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      onGenerateRoute: (RouteSettings settings) {
        //mapeamento de rotas usando uma transição animada de "FadeIn"
        switch (settings.name) {
          case '/':
            return FadeInTransitionRoute(widget: HomeScreen());
            break;
        }
      },
    );
  }
}
