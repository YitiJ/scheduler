import 'dart:async';

class Validators {
  final validateTitle =
      StreamTransformer<String, String>.fromHandlers(handleData: (title, sink) {
    if (title != null && title.length > 0 && title.length < 100) {
      sink.add(title);
    } else {
      // sink.add(title);
      sink.addError('Enter a valid title (less than 100 characters, currently ${title.length} characters');
    }
  });

  final validateText =
      StreamTransformer<String, String>.fromHandlers(handleData: (note, sink) {
    if (note.length < 100) {
      sink.add(note);
    } else {
      // sink.add(note);
      sink.addError('Enter a valid note (less than 100 characters, currently ${note.length} characters');
    }
  });
}