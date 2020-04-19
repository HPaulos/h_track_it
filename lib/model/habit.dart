import 'package:flutter/foundation.dart';

import 'category.dart';
import 'task.dart';

class HabitModel {
  HabitModel(
      {@required this.name,
      @required this.start,
      @required this.end,
      @required this.category});

  String name;
  String description;
  DateTime start;
  DateTime end;
  CategoryModel category;

  List<String> recurrence;

  DateTime get upcomming => DateTime.now();
  DateTime get last => DateTime.now();

  @override
  String toString() {
    return '''{name: ${name}, description: ${description},
         start: ${start.toIso8601String()}}, end: ${end.toIso8601String()}, category: ${category.name}''';
  }
}
