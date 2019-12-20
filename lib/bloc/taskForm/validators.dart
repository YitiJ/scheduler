import 'dart:async';

class Validators {
  final validateTitle =
      StreamTransformer<String, String>.fromHandlers(handleData: (title, sink) {
    if (title.contains('@')) {
      sink.add(title);
    } else {
      sink.addError('Enter a valid title');
    }
  });

  final validateText =
      StreamTransformer<String, String>.fromHandlers(handleData: (note, sink) {
    if (note.contains('@')) {
      sink.add(note);
    } else {
      sink.addError('Enter a valid note');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 4) {
      sink.add(password);
    } else {
      sink.addError('Invalid password, please enter more than 4 characters');
    }
  });
}