import 'category.dart';
import 'task.dart';

class Habit {
  String name;
  DateTime start;
  DateTime end;
  CategoryModel category;
  Task upcomming;
  Task last;
  List<Task> tasks;
}
