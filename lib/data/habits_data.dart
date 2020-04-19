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
        category: CategoryModel(
            name: 'Health',
            color: Colors.red,
            icon: FontAwesomeIcons.solidHeart)),

    HabitModel(
      end: DateTime.now(),
      start: DateTime.now(),
      name: "Read Bible",
      category: CategoryModel(
          name: 'Spritual', color: Colors.green, icon: FontAwesomeIcons.pray),
    ),
    HabitModel(
      end: DateTime.now(),
      start: DateTime.now(),
      name: "Read 100 pages",
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
