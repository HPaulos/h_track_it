import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../common/habit_item.dart';
import '../common/search_widget.dart';
import '../data/habits_data.dart';
import '../data/trackit_theme_data.dart';
import '../model/habit.dart';

import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class TasksPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TasksPageState();
  }
}

class _TasksPageState extends State<TasksPage> {
  List<HabitModel> _habits;
  HabitModel _updated;
  bool _filterring;
  bool _showCanceled;
  bool _showCompleted;
  bool _showPending;

  DateTime _startDate;

  @override
  void initState() {
    super.initState();
    _filterring = false;
    _startDate = DateTime.now();
    _showCanceled = false;
    _showCompleted = false;
    _showPending = true;
  }

  @override
  Widget build(BuildContext context) {
    _habits = Provider.of<HabitData>(context).habits;
    final colorThree = Provider.of<TrackitThemeData>(context).colorThree;

    final colorTwo = Provider.of<TrackitThemeData>(context).colorTwo;
    final colorOne = Provider.of<TrackitThemeData>(context).colorOne;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks List"),
        leading: Container(),
        actions: const <Widget>[],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 7, top: 7),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SearchWidget(FocusNode(), TextEditingController()),
                ),
                RawMaterialButton(
                  elevation: 7,
                  fillColor: Provider.of<TrackitThemeData>(context).colorTwo,
                  padding: const EdgeInsets.all(12),
                  shape: const CircleBorder(),
                  hoverColor: colorOne,
                  focusColor: colorOne,
                  highlightColor: colorTwo,
                  onPressed: () {
                    setState(() {
                      _filterring = !_filterring;
                    });
                  },
                  child: Icon(
                    FontAwesomeIcons.filter,
                    color: _filterring ? colorThree : null,
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: _filterring,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 7, top: 7),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(23),
                        child: Theme(
                          data: ThemeData(
                              primaryColor: colorTwo, fontFamily: "Roboto"),
                          child: Container(
                            padding: const EdgeInsets.only(left: 21),
                            height: 41,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  "From ",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  DateFormat.MMMEd().format(_startDate),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                      Column(
                        children: <Widget>[
                          RawMaterialButton(
                            elevation: 7,
                            fillColor:
                                Provider.of<TrackitThemeData>(context).colorTwo,
                            padding: const EdgeInsets.all(12),
                            shape: const CircleBorder(),
                            hoverColor:
                                Provider.of<TrackitThemeData>(context).colorOne,
                            focusColor:
                                Provider.of<TrackitThemeData>(context).colorOne,
                            highlightColor: colorTwo,
                            onPressed: () {
                              setState(() async {
                                final date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2012),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365 * 10)),
                                    initialDate: DateTime.now());
                                if (date != null) {
                                  setState(() {
                                    _startDate = date;
                                  });
                                }
                              });
                            },
                            child: Icon(
                              FontAwesomeIcons.calendarDay,
                              color: _filterring ? colorThree : null,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                     ],
              ),
            ),
          ),
          Expanded(
            child: Builder(builder: (bContext) {
              if (_habits.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(27),
                    child: Text(
                      "No habits is found.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 7),
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
                                style: TextStyle(
                                    color: Colors.black, fontSize: 19),
                              ),
                              const Spacer(),
                              const Text(
                                "Undo",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 19),
                              )
                            ],
                          ),
                        ),
                      ));
                    },
                    background: Container(
                      margin: const EdgeInsets.only(
                        bottom: 27,
                        top: 27,
                      ),
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(21),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 19),
                              child: Icon(
                                FontAwesomeIcons.times,
                                size: 27,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Cancel",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 27),
                            ),
                          ],
                        ),
                      ),
                    ),
                    secondaryBackground: Container(
                      margin: const EdgeInsets.only(
                        bottom: 27,
                        top: 27,
                      ),
                      color: Colors.green,
                      child: Padding(
                        padding: const EdgeInsets.all(21),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 19),
                              child: Icon(
                                FontAwesomeIcons.check,
                                size: 27,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Complete",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 27),
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
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedIconTheme: IconThemeData(
            color: Provider.of<TrackitThemeData>(context).colorThree),
        selectedIconTheme: IconThemeData(color: colorThree),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.objectGroup),
            title: const Text('Categories'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.list,
              color: colorThree.withOpacity(0.3),
            ),
            title: const Text('Tasks'),
          ),
        ],
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/categories');
          }
        },
      ),
    );
  }
}
