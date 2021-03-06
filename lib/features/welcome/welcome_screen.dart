import 'package:app/components/fab_button.dart';
import 'package:app/components/transition_button.dart';
import 'package:app/controllers/sync_controller.dart';
import 'package:app/models/sync_model.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({this.analytics});
  final FirebaseAnalytics analytics;
  @override
  _WelcomeScreenState createState() =>
      _WelcomeScreenState(analytics: analytics);
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  _WelcomeScreenState({this.analytics});
  final FirebaseAnalytics analytics;
  @override
  void initState() {
    super.initState();

    analytics
        .logEvent(name: 'Teste', parameters: {'função': 'deu bom!'}).then((_) {
      print('enviado!');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SyncController _syncController =
        BlocProvider.getBloc<SyncController>();
    return Scaffold(
      floatingActionButton: StreamBuilder<SyncModel>(
          stream: _syncController.outStream,
          builder: (context, snapshot) {
            return (snapshot.hasData && snapshot.data.completado == false)
                ? FloatingActionButton.extended(
                    onPressed: _syncController.increment,
                    label: Text('Sincronizando logins ' +
                        snapshot.data.atual.toString() +
                        ' de ' +
                        snapshot.data.total.toString()),
                    icon: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : FloatingActionButton.extended(
                    onPressed: _syncController.increment,
                    label: Text('Logins sincronizados!'),
                    icon: Icon(Icons.check),
                  );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FabButton(
                  color: Colors.blue,
                  route: '/home',
                  text: 'Home',
                  onPressed: null),
              FabButton(
                color: Colors.blue,
                route: '/home',
                text: 'Home',
                onPressed: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
