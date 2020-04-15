import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/category.dart';
import '../model/habit.dart';
import '../model/task.dart';

class HabitData extends ChangeNotifier {
  final List<HabitModel> _habits = [
    HabitModel(
      end: DateTime.now(),
      start: DateTime.now(),
      name: "Drink Water",
      upcomming: Task(
          dateTime: DateTime.now(),
          duration: const Duration(hours: 1),
          status: Status.pending),
      last: Task(
          dateTime: DateTime.now(),
          duration: const Duration(hours: 1),
          status: Status.pending),
      category: CategoryModel(
          name: 'Health', color: Colors.red, icon: FontAwesomeIcons.solidHeart),
    ),
    HabitModel(
      end: DateTime.now(),
      start: DateTime.now(),
      name: "Read Bible",
      upcomming: Task(
          dateTime: DateTime.now(),
          duration: const Duration(hours: 1),
          status: Status.pending),
      last: Task(
          dateTime: DateTime.now(),
          duration: const Duration(hours: 1),
          status: Status.pending),
      category: CategoryModel(
          name: 'Spritual', color: Colors.green, icon: FontAwesomeIcons.pray),
    ),
    HabitModel(
      end: DateTime.now(),
      start: DateTime.now(),
      name: "Read 100 pages",
      upcomming: Task(
          dateTime: DateTime.now(),
          duration: const Duration(hours: 1),
          status: Status.pending),
      last: Task(
          dateTime: DateTime.now(),
          duration: const Duration(hours: 1),
          status: Status.pending),
      category: CategoryModel(
          name: 'Reading',
          color: Colors.amber,
          icon: FontAwesomeIcons.bookOpen),
    ),
  ];

  List<HabitModel> get habits => _habits;

  List<HabitModel> searchByCategory(String name) {
    return habits
        .where(
            (habit) => habit.category.name.toLowerCase() == name.toLowerCase())
        .toList();
  }

  void add(HabitModel habit) {
    _habits.insert(0, habit);
    notifyListeners();
  }

  
}
