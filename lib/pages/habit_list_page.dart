import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HabitListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HabitListPageState();
  }
}

class _HabitListPageState extends State<HabitListPage> {
  HabitItem updated;

  List<HabitItem> habits = [
    HabitItem(
        name: "Read Bible",
        upcommingTime: "6:00 PM",
        startDate: "04/21/2020",
        endDate: "04/21/2020",
        icon: FontAwesomeIcons.bookOpen,
        categoryColor: "0xFF800000",
        completed: 5,
        total: 10),
    HabitItem(
        name: "Do 100 pushups",
        upcommingTime: "5:00 PM",
        startDate: "04/21/2020",
        endDate: "04/21/2020",
        icon: FontAwesomeIcons.running,
        categoryColor: "0xFFFF0000",
        completed: 5,
        total: 10),
    HabitItem(
        name: "Night Prayer",
        upcommingTime: "10:00 PM",
        startDate: "04/21/2020",
        endDate: "04/21/2020",
        icon: FontAwesomeIcons.pray,
        categoryColor: "0xFF0000FF",
        completed: 5,
        total: 10),
    HabitItem(
        name: "Call Family",
        upcommingTime: "6:00 PM",
        startDate: "04/21/2020",
        endDate: "04/21/2020",
        icon: FontAwesomeIcons.solidHeart,
        categoryColor: "0xFF00FF70",
        completed: 5,
        total: 10),
    HabitItem(
        name: "Read Bible",
        upcommingTime: "6:00 PM",
        startDate: "04/21/2020",
        endDate: "04/21/2020",
        icon: FontAwesomeIcons.bookOpen,
        categoryColor: "0xFF800000",
        completed: 5,
        total: 10),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0D4B9),
      appBar: AppBar(
        title: Text("Habits"),
      ),
      body: Builder(builder: (bContext) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 7),
          itemCount: habits.length,
          itemBuilder: (BuildContext ctx, int index) {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                this.updated = habits[index];
                this.habits.removeAt(index);
                Scaffold.of(bContext).hideCurrentSnackBar();
                Scaffold.of(bContext).showSnackBar(new SnackBar(
                  backgroundColor: Color(0xFFE0D4B9),
                  duration: Duration(seconds: 3),
                  content: InkWell(
                    onTap: () {
                      Scaffold.of(bContext).hideCurrentSnackBar();
                      setState(() {
                        habits.insert(index, updated);
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                          "1 Task Update",
                          style: TextStyle(color: Colors.black, fontSize: 19),
                        ),
                        Spacer(),
                        Text(
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
                  child: habits[index]),
            );
          },
        );
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(21.0),
        child: FloatingActionButton(
            elevation: 12,
            onPressed: () {
              Navigator.pushNamed(context, '/newHabit');
            },
            child: Icon(
              Icons.add,
              size: 27,
              color: Colors.black,
            ),
            backgroundColor: Color(0xFFE0D4B9)),
      ),
    );
  }
}

class HabitItem extends StatelessWidget {
  String name;
  String upcommingTime;
  String startDate;
  String endDate;
  String categoryColor;
  IconData icon;
  int completed = 7;
  int total = 10;

  HabitItem(
      {@required this.name,
      @required this.upcommingTime,
      @required this.startDate,
      @required this.endDate,
      @required this.icon,
      @required this.categoryColor,
      @required this.completed,
      @required this.total});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/habitdetail');
      },
      child: Card(
          color: Color(0xFFF2EBDA),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                        width: 3, color: Color(int.parse(categoryColor))))),
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
                                    icon,
                                    size: 21,
                                    color: Color(int.parse(categoryColor)),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 19,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    "Upcomming",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Text(
                                  upcommingTime,
                                  style: TextStyle(
                                    fontSize: 19,
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
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 3, top: 3),
                                  child: Text(
                                    "Start Date",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Text(
                                  startDate,
                                  style: TextStyle(
                                    fontSize: 19,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 3, top: 3),
                                  child: Text(
                                    "End Date",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Text(
                                  startDate,
                                  style: TextStyle(
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
                        flex: completed,
                        child: Container(
                            color: Colors.green,
                            child: SizedBox(
                              height: 3,
                            ))),
                    Expanded(
                        flex: total - completed,
                        child: Container(
                            color: Colors.white,
                            child: SizedBox(
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
