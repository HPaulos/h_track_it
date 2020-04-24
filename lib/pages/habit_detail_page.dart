import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:track_it/data/trackit_theme_data.dart';

class HabitDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HabitDetailPageState();
  }
}

class _HabitDetailPageState extends State<HabitDetailPage> {
  String title = "Read Books";
  String note =
      "Sometimes a layout is designed around the flexible properties of a Column, but there is the concern that in some cases, there might not be enough room to see the entire contents.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Habit Detail"),
        ),
        body: Container(
          color: Provider.of<TrackitThemeData>(context).colorTwo,
          padding: const EdgeInsets.all(21),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: Row(
                  children: <Widget>[
                    Flexible(
                        child: Text(
                      note,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ))
                  ],
                ),
              ),
              Divider(
                color: Colors.red,
                height: 27,
                indent: 21,
                endIndent: 21,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Upcomming",
                            style: TextStyle(
                              fontSize: 19,
                            ),
                          ),
                          Text(
                            "6:00 PM Today",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 7),
                                child: Icon(
                                  FontAwesomeIcons.check,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                "Last Task",
                                style: TextStyle(
                                  fontSize: 19,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "6:00 PM Yesterday",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
