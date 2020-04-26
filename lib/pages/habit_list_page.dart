import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:track_it/common/habit_item.dart';

import '../data/habits_data.dart';
import '../model/category.dart';
import '../model/habit.dart';

class HabitListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HabitListPageState();
  }
}

class _HabitListPageState extends State<HabitListPage> {
  CategoryModel _category;
  HabitModel _updated;
  List<HabitModel> _habits;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _category = ModalRoute.of(context).settings.arguments as CategoryModel;

    if (_category != null) {
      _habits =
          Provider.of<HabitData>(context).searchByCategory(_category.name);
    } else {
      _habits = Provider.of<HabitData>(context).habits;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Habits"),
      ),
      body: Builder(builder: (bContext) {
        if (_habits.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(27),
              child: Text(
                "No habits under ${_category.name} is found.",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 7),
          itemCount: _habits.length,
          itemBuilder: (ctx, index) {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                _updated = _habits[index];
                _habits.removeAt(index);
                Scaffold.of(bContext).hideCurrentSnackBar();
                Scaffold.of(bContext).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 3),
                  content: InkWell(
                    onTap: () {
                      Scaffold.of(bContext).hideCurrentSnackBar();
                      setState(() {
                        _habits.insert(index, _updated);
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        const Text(
                          "1 Task Update",
                          style: TextStyle(color: Colors.black, fontSize: 19),
                        ),
                        const Spacer(),
                        const Text(
                          "Undo",
                          style: TextStyle(color: Colors.blue, fontSize: 19),
                        )
                      ],
                    ),
                  ),
                ));
              },
              background: Container(
                child: Padding(
                  padding: const EdgeInsets.all(21.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 19),
                        child: Icon(
                          FontAwesomeIcons.times,
                          size: 27,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 27),
                      ),
                    ],
                  ),
                ),
                margin: const EdgeInsets.only(
                  bottom: 27,
                  top: 27,
                ),
                color: Colors.red,
              ),
              secondaryBackground: Container(
                margin: const EdgeInsets.only(
                  bottom: 27,
                  top: 27,
                ),
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(21.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 19),
                        child: Icon(
                          FontAwesomeIcons.check,
                          size: 27,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Complete",
                        style: TextStyle(color: Colors.white, fontSize: 27),
                      ),
                    ],
                  ),
                ),
              ),
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: HabitItem(_habits[index])),
            );
          },
        );
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(21),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/newHabit', arguments: _category);
          },
          child: const Icon(
            Icons.add,
            size: 27,
          ),
        ),
      ),
    );
  }
}
