import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: const Color(0xFFE0D4B9),
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
                Scaffold.of(bContext).showSnackBar(new SnackBar(
                  backgroundColor: const Color(0xFFE0D4B9),
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
                margin: const EdgeInsets.only(
                  bottom: 27,
                  top: 27,
                ),
                color: Colors.green,
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
          elevation: 12,
          onPressed: () {
            Navigator.pushNamed(context, '/newHabit', arguments: _category);
          },
          backgroundColor: const Color(0xFFFC9C35),
          child: const Icon(
            Icons.add,
            size: 27,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

@immutable
class HabitItem extends StatelessWidget {
  HabitItem(HabitModel habitModel)
      : _name = habitModel.name,
        _upcommingDate = DateFormat.MEd().format(habitModel.upcomming),
        _start = DateFormat.MEd().format(habitModel.start),
        _end = DateFormat.MEd().format(habitModel.end),
        _color = habitModel.category.color,
        _icon = habitModel.category.icon,
        _completed = 1,
        _total = 1;

  final String _name;
  final String _upcommingDate;
  final String _start;
  final String _end;
  final Color _color;
  final IconData _icon;
  final int _completed;
  final int _total;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/habitdetail');
      },
      child: Card(
          elevation: 5,
          color: const Color(0xFFF2EBDA),
          child: Container(
            decoration: BoxDecoration(
                border: Border(left: BorderSide(width: 3, color: _color))),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 21, left: 12, right: 12, bottom: 16),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 7),
                                  child: Icon(
                                    _icon,
                                    size: 21,
                                    color: _color,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  _name,
                                  style: const TextStyle(
                                    fontSize: 19,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    "Upcomming",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Text(
                                  _upcommingDate ?? "no upcomming task",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7, bottom: 7),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 3, top: 3),
                                  child: Text(
                                    "Previous Date",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Text(
                                  _start,
                                  style: const TextStyle(
                                    fontSize: 19,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 3, top: 3),
                                  child: Text(
                                    "Next Date",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Text(
                                  _end,
                                  style: const TextStyle(
                                    fontSize: 19,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: _completed,
                        child: Container(
                            color: Colors.green,
                            child: const SizedBox(
                              height: 3,
                            ))),
                    Expanded(
                        flex: _total - _completed,
                        child: Container(
                            color: Colors.white,
                            child: const SizedBox(
                              height: 3,
                            )))
                  ],
                )
              ],
            ),
          )),
    );
  }
}
