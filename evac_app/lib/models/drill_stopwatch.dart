import 'dart:async';

class DrillStopwatch {
  late StreamController<int> streamController;
  late Timer timer;
  int counter = 0;

  void onCancel() {
    timer.cancel();
    counter = 0;
    streamController.close();
  }

  void tick(_) {
    counter++;
    streamController.add(counter);
  }

  DrillStopwatch() {
    this.timer = Timer.periodic(Duration(seconds: 1), tick);
    this.streamController = new StreamController<int>(
      sync: true,
      onCancel: onCancel,
    );
  }

  Stream<int> getStream() {
    return this.streamController.stream;
  }
}
