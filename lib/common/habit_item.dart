import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/habits_data.dart';
import '../model/category.dart';
import '../model/habit.dart';

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
