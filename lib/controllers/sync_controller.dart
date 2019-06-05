import 'dart:async';

import 'package:app/models/sync_model.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SyncController extends BlocBase {
  SyncController() {
    this._increment();
  }

  var _controller = BehaviorSubject<SyncModel>.seeded(SyncModel(total: 20));
  Stream<SyncModel> get outCounter => this._controller.stream;
  Sink<SyncModel> get inCounter => this._controller.sink;

  void _increment() {
    Timer.periodic(const Duration(seconds: 2), (_) {
      if (this._controller.value.atual < this._controller.value.total)
        this._controller.value.atual += 1;
      else
        this._controller.value.completado = true;
      this.inCounter.add(this._controller.value);
      Firestore.instance
          .collection('books')
          .document()
          .setData({'title': 'title', 'author': 'author'});
      Firestore.instance
          .collection('book')
          .where("title", isEqualTo: "title")
          .snapshots()
          .listen(
              (data) => data.documents.forEach((doc) => print(doc["title"])));
    });
  }

  void increment() {
    this._controller.value.total += 1;
    this._controller.value.completado = false;
    this.inCounter.add(this._controller.value);
  }

  @override
  void dispose() {
    this._controller.close();
    super.dispose();
  }
}
