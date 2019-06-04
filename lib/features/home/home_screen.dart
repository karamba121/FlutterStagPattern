import 'package:app/components/transition_button.dart';
import 'package:app/controllers/sync_controller.dart';
import 'package:app/models/sync_model.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SyncController _syncController =
        BlocProvider.getBloc<SyncController>();
    return Scaffold(
      floatingActionButton: StreamBuilder<SyncModel>(
          stream: _syncController.outCounter,
          builder: (context, snapshot) {
            return snapshot.data.completado == false
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
              TransitionButton(
                onPressed: null,
                color: Colors.pink,
                route: '/',
                text: 'Welcome',
                canGoBack: true,
              ),
              RaisedButton(
                onPressed: _syncController.increment,
                child: Text('Aumentar fila'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
