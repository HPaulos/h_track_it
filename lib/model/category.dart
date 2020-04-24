import 'dart:ui';

import 'package:flutter/widgets.dart';

class CategoryModel {
  
  CategoryModel(
      {@required this.name, @required this.color, @required this.icon});


  String name;
  IconData icon;
  Color color;
}
