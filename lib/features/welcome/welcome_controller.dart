import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class WelcomeController extends BlocBase {
  var _controller = BehaviorSubject<int>.seeded(0);
  Stream<int> get outCounter => this._controller.stream;
  Sink<int> get inCounter => this._controller.sink;

  increment() {
    this.inCounter.add(this._controller.value + 1);
  }

  @override
  void dispose() {
    this._controller.close();
    super.dispose();
  }
}
