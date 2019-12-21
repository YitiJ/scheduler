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

  // final validateDate =
  //     StreamTransformer<DateTime, DateTime>.fromHandlers(handleData: (date, sink) {
  //   if (true) {
  //     print(date);
  //     sink.add(date);
  //   }
  // });
}