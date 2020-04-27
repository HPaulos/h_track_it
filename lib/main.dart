import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/habits_data.dart';
import 'data/trackit_theme_data.dart';
import 'data/category_data.dart';
import 'pages/add_category.dart';
import 'pages/add_habit_page.dart';
import 'pages/category_page.dart';
import 'pages/habit_detail_page.dart';
import 'pages/habit_list_page.dart';
import 'pages/tasks_page.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => CategoryData()),
      ChangeNotifierProvider(create: (_) => HabitData()),
      ChangeNotifierProvider(create: (_) => TrackitThemeData()),
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorOne = Provider.of<TrackitThemeData>(context).colorOne;
    final colorTwo = Provider.of<TrackitThemeData>(context).colorTwo;
    final colorThree = Provider.of<TrackitThemeData>(context).colorThree;
    final colorOneText = Provider.of<TrackitThemeData>(context).colorOneText;

    return MaterialApp(
      theme: ThemeData(
        snackBarTheme: Theme.of(context).snackBarTheme.copyWith(
          backgroundColor: colorTwo
        ),
        textTheme: Theme.of(context).textTheme.copyWith(),
        cardColor: Provider.of<TrackitThemeData>(context).colorTwo,
        canvasColor: colorTwo,
        buttonColor: colorOne,
        disabledColor: colorTwo,
        accentColor: colorThree,
        dialogBackgroundColor: Provider.of<TrackitThemeData>(context).colorTwo,
        floatingActionButtonTheme:
            Theme.of(context).floatingActionButtonTheme.copyWith(
                  backgroundColor:
                      Provider.of<TrackitThemeData>(context).colorThree,
                  elevation: 12,
                  foregroundColor: Colors.black,
                ),
        scaffoldBackgroundColor:
            Provider.of<TrackitThemeData>(context).colorOne,
        backgroundColor: colorTwo,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
            iconTheme: IconThemeData(
              color: colorThree,
              size: 19,
            ),
            textTheme: const TextTheme(
                title: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.bold))),
        primaryColor: colorTwo,
      ),
      home: SafeArea(child: CategoryPage()),
      routes: {
        '/habits': (context) => HabitListPage(),
        '/categories': (context) => CategoryPage(),
        '/habitdetail': (context) => HabitDetailPage(),
        '/calendar': (context) => TasksPage(),
        '/newCategory': (context) => AddCategoryPage(),
        '/newHabit': (context) => AddHabitPage()
      },
    );
  }
}
