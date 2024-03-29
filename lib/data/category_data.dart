import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../model/category.dart';

class CategoryData with ChangeNotifier {
  final List<CategoryModel> _categories = [
    CategoryModel(
        name: 'Health', color: Colors.red, icon: FontAwesomeIcons.solidHeart),
    CategoryModel(
        name: 'Spritual', color: Colors.green, icon: FontAwesomeIcons.pray),
    CategoryModel(
        name: 'Reading', color: Colors.amber, icon: FontAwesomeIcons.bookOpen),
    CategoryModel(
        name: 'Excercise', color: Colors.blue, icon: FontAwesomeIcons.running),
    CategoryModel(
        name: 'All Habits', color: Colors.brown, icon: FontAwesomeIcons.list),
  ];

  List<CategoryModel> get categories => _categories;

  void add(CategoryModel category) {
    if (searchCategoryByName(category.name)) {
      print("Throwing exception");
      throw DuplicateDataException(
          "Group with name ${category.name} already exists.");
    }

    _categories.insert(0, category);
    notifyListeners();
  }

  void remove(CategoryModel category) {
    _categories.remove(category);
    notifyListeners();
  }

  void update(CategoryModel old, CategoryModel updated) {
    final indeOfOld = _categories.indexOf(old);
    _categories.replaceRange(indeOfOld, indeOfOld + 1, [updated]);
    notifyListeners();
  }

  bool searchCategoryByName(String name) {
    return _categories.indexWhere((category) =>
            category.name.toLowerCase().trim() == name.toLowerCase()) !=
        -1;
  }
  
}

class DuplicateDataException implements Exception {
  const DuplicateDataException(String message) : _message = message;

  final String _message;

  String get message => _message;
}
