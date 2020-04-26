import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:track_it/common/habit_item.dart';
import 'package:track_it/common/search_widget.dart';
import 'package:track_it/data/habits_data.dart';
import 'package:track_it/data/trackit_theme_data.dart';
import 'package:track_it/model/habit.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarPageState();
  }
}

class _CalendarPageState extends State<CalendarPage> {
  List<HabitModel> _habits;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _habits = Provider.of<HabitData>(context).habits;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks List"),
        leading: Container(),
        actions: const <Widget>[],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 7),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: SearchWidget(FocusNode(), TextEditingController()))
              ],
            ),
          ),
          Expanded(
            child: Builder(builder: (bContext) {
              if (_habits.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(27),
                    child: Text(
                      "No habits is found.",
                      style: const TextStyle(fontSize: 16),
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
                      // _updated = _habits[index];
                      _habits.removeAt(index);
                      Scaffold.of(bContext).hideCurrentSnackBar();
                      Scaffold.of(bContext).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 3),
                        content: InkWell(
                          onTap: () {
                            Scaffold.of(bContext).hideCurrentSnackBar();
                            setState(() {
                              // _habits.insert(index, _updated);
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 27),
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
        selectedIconTheme: IconThemeData(
            color: Provider.of<TrackitThemeData>(context).colorThree),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.layerGroup),
            title: Text('Categories'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.list),
            title: Text('Calendar'),
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
