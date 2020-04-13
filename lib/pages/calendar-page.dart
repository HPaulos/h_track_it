import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarPageState();
  }
}

class _CalendarPageState extends State<CalendarPage> {
  DateFormat dateFormatter = DateFormat("MM/dd/yyyy");
  DateFormat monthFormatter = DateFormat("MMMM");
  DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    this.selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0D4B9),
      appBar: AppBar(
        title: const Text("Tasks List"),
        leading: Container(),
        actions: const <Widget>[],
      ),
      body: ListView(
        children: <Widget>[
          Card(
            margin: EdgeInsets.only(left: 21, right: 21, bottom: 3),
            color: Color(0xFFF2EBDA),
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      FontAwesomeIcons.arrowLeft,
                      size: 19,
                    ),
                    onPressed: () {
                      setState(() {
                        this.selectedDate = DateTime(this.selectedDate.year,
                            this.selectedDate.month - 1, 1);
                      });
                    }),
                Expanded(
                    child: Center(
                        child: Column(
                  children: <Widget>[
                    Text(
                      monthFormatter.format(selectedDate),
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dateFormatter.format(selectedDate),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ))),
                IconButton(
                    icon: Icon(FontAwesomeIcons.arrowRight),
                    onPressed: () {
                      setState(() {
                        this.selectedDate = DateTime(this.selectedDate.year,
                            this.selectedDate.month + 1, 1);
                      });
                    }),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.only(left: 21, right: 21, bottom: 12),
            color: Color(0xFFF2EBDA),
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Column(
                children: <Widget>[
                  Row(
                    children: List.generate(7, (index) {
                      return Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            left: 7.0, right: 7, bottom: 1, top: 7),
                        child: Center(
                          child:
                              Text(["M", "T", "W", "T", "F", "S", "S"][index]),
                        ),
                      ));
                    }),
                  ),
                  _buildDateButtons()
                ],
              ),
            ),
          ),
          //event list
          Card(
            margin: EdgeInsets.only(left: 21, right: 21, bottom: 21),
            color: Color(0xFFF2EBDA),
            child: Padding(
              padding: EdgeInsets.only(left: 21, right: 21, bottom: 21),
              child: Container(),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFF2EBDA),
        unselectedIconTheme: IconThemeData(color: Color(0x88FC9C35)),
        selectedIconTheme: IconThemeData(color: Color(0xFFFC9C35)),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.layerGroup),
            title: Text('Categories'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.calendar),
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

  Widget _buildDateButtons() {
    DateTime firstDate = DateTime(selectedDate.year, selectedDate.month, 1);
    DateTime lastDate = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    List<Widget> rows = [];
    Widget dummyElement = Expanded(child: Container());

    int addedDays = 0;
    List<Widget> dayButtons = [];

    while (addedDays < lastDate.day) {
      dayButtons = [];
      for (int i = 1; i <= 7; i++) {
        if (addedDays == 0) {
          if (firstDate.weekday == i) {
            addedDays++;
            dayButtons.add(_buildCircularButtons(addedDays));
          } else {
            dayButtons.add(dummyElement);
          }
        } else {
          addedDays++;
          if (addedDays <= lastDate.day) {
            dayButtons.add(_buildCircularButtons(addedDays));
          } else {
            dayButtons.add(dummyElement);
          }
        }
      }
      rows.add(Row(
        children: dayButtons,
      ));
    }
    return Column(children: rows);
  }

  Widget _buildCircularButtons(int day) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(0.0),
      child: MaterialButton(
          color: day == this.selectedDate.day
              ? Color(0xFFFC9C35)
              : Color(0xFFE0D4B9),
          shape: CircleBorder(),
          padding: EdgeInsets.all(12),
          child: Text(day.toString()),
          onPressed: () {
            setState(() {
              this.selectedDate = DateTime(
                  this.selectedDate.year, this.selectedDate.month, day);
            });
          }),
    ));
  }
}
