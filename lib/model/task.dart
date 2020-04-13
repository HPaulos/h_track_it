import 'package:flutter/foundation.dart';

enum Status { complete, pending, canceled, postPoned }

class Task {
  Task(
      {@required this.dateTime,
      @required this.status,
      @required this.duration});

  Duration duration;
  DateTime dateTime;
  Status status;
}
