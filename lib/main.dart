import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/category_data.dart';
import 'pages/add_category.dart';
import 'pages/add_habit_page.dart';
import 'pages/calendar-page.dart';
import 'pages/category_page.dart';
import 'pages/habit_detail_page.dart';
import 'pages/habit_list_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(create: (_) => CategoryData()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          backgroundColor: const Color(0xFFF2EBDA),
          appBarTheme: Theme.of(context).appBarTheme.copyWith(
              iconTheme: const IconThemeData(
                color: Colors.black,
                size: 19,
              ),
              textTheme: const TextTheme(
                  title: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold))),
          primaryColor: const Color(0xFFF2EBDA),
        ),
        home: SafeArea(child: CategoryPage()),
        routes: {
          '/habits': (context) => HabitListPage(),
          '/categories': (context) => CategoryPage(),
          '/habitdetail': (context) => HabitDetailPage(),
          '/calendar': (context) => CalendarPage(),
          '/newCategory': (context) => AddCategoryPage(),
          '/newHabit': (context) => AddHabitPage()
        },
      ),
    );
  }
}
