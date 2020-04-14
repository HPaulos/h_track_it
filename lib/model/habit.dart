import 'package:flutter/foundation.dart';

import 'category.dart';
import 'task.dart';

class HabitModel {
  HabitModel(
      {@required this.name,
      @required this.start,
      @required this.end,
      @required this.category,
      @required this.upcomming,
      @required this.last});

  String name;
  String note;
  DateTime start;
  DateTime end;
  CategoryModel category;
  Task upcomming;
  Task last;
  List<Task> tasks;
}
