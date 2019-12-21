import 'dart:async';

enum Option {timeline, todo}

class SegmentedControlBloc {
  final StreamController<Option> _segmentController = StreamController<Option>.broadcast();

  Option defaultOption = Option.timeline;

  Stream<Option> get segmentStream => _segmentController.stream;

  void changePage(Option ind) {
    // print(ind);
    _segmentController.sink.add(ind);
  }

  close() {
    _segmentController?.close();
  }
}