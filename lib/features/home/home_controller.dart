import 'package:app/components/messages.dart';
import 'package:app/models/book.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HomeController extends BlocBase {
  HomeController({this.context}) {
    this.getBooks();
  }
  final BuildContext context;
  var _lista = List<Book>(1);

  var _controller = BehaviorSubject<List<Book>>.seeded(null);
  Stream<List<Book>> get outListOfBooks => this._controller.stream;
  Sink<List<Book>> get inListOfBooks => this._controller.sink;

  var book = Firestore.instance.document('books/Código da Vinci');

  void insertBook() {
    var newBook = {'title': 'Código da Vinci', 'author': 'Dan Brown'};
    book.setData(newBook).whenComplete(() {
      print('Livro inserido com sucesso!');
      this.getBooks();
    }).catchError((e) {
      showErrorMessage(e.message, context);
    });
  }

  void updateBook() {
    var updatedBook = {
      'title': 'Código da Vinci atualizado',
      'author': 'Dan Brown atualizado'
    };

    book.updateData(updatedBook).whenComplete(() {
      print('Livro atualizado com sucesso!');
      this.getBooks();
    }).catchError((e) {
      showErrorMessage(e.message, context);
    });
  }

  void deleteBook() {
    book.delete().whenComplete(() {
      print('Livro Deletado com sucesso!');
      this.getBooks();
    }).catchError((e) {
      showErrorMessage(e.message, context);
    });
  }

  void getBooks() {
    book.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        this._lista = List<Book>(1);
        this._lista[0] = Book(
            title: snapshot.data['title'], author: snapshot.data['author']);
      } else
        this._lista = null;
      this._controller.value = this._lista;
    }, onError: (e) {
      showErrorMessage(e.message, context);
    });
  }
}
