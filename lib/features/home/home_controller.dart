import 'package:app/models/book.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class HomeController extends BlocBase {
  var _controller = BehaviorSubject<List<Book>>();
  Stream<List<Book>> get outListOfBooks => this._controller.stream;
  Sink<List<Book>> get inListOfBooks => this._controller.sink;

  var book = Firestore.instance.document('books/Código da Vinci');

  void insertBook() {
    var newBook = {'title': 'Código da Vinci', 'author': 'Dan Brown'};
    book.setData(newBook).whenComplete(() {
      print('Livro inserido com sucesso!');
    });
  }

  void updateBook() {
    var updatedBook = {
      'title': 'Código da Vinci atualizado',
      'author': 'Dan Brown atualizado'
    };

    book.updateData(updatedBook).whenComplete(() {
      print('Livro atualizado com sucesso!');
    });
  }

  void deleteBook() {
    book.delete().whenComplete(() {
      print('Livro Deletado com sucesso!');
    });
  }

  void getBooks() {
    var list = List<Book>();
    book.snapshots().listen((snapshot) {
      list.add(
          Book(title: snapshot.data['title'], author: snapshot.data['author']));
      inListOfBooks.add(list);
    });
  }
}
