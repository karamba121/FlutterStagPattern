import 'dart:async';

import 'package:app/models/sync_model.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class SyncController extends BlocBase {
  SyncController() {
    this._increment();
  }

  var _controller = BehaviorSubject<SyncModel>.seeded(SyncModel(total: 20));
  Stream<SyncModel> get outStream => this._controller.stream;
  Sink<SyncModel> get inSink => this._controller.sink;

  void _increment() {
    Timer.periodic(const Duration(seconds: 2), (_) {
      if (this._controller.value.atual < this._controller.value.total)
        this._controller.value.atual += 1;
      else
        this._controller.value.completado = true;

      this.inSink.add(this._controller.value);
    });
  }

  void increment() {
    this._controller.value.total += 1;
    this._controller.value.completado = false;
    this.inSink.add(this._controller.value);
  }

  @override
  void dispose() {
    this._controller?.close();
    super.dispose();
  }
}
