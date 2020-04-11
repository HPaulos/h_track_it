import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:track_it/model/habit.dart';

class AddHabitPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddHabitPageState();
  }
}

class _AddHabitPageState extends State<AddHabitPage> {
  Habit habit;

  @override
  void initState() {
    super.initState();
    habit = Habit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0D4B9),
      appBar: AppBar(
        title: Text("New Category"),
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.black),
          onPressed: () => cancel(context),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 21, right: 21, top: 12, bottom: 7),
            child: Card(
              color: Color(0xFFF2EBDA),
              child: Container(
                padding:
                    EdgeInsets.only(left: 12, right: 12, top: 7, bottom: 7),
                child: Column(
                  children: <Widget>[],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool cancel(BuildContext context) => Navigator.of(context).pop();
}
