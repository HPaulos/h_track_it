import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:track_it/data/trackit_theme_data.dart';
import '../data/habits_data.dart';
import '../model/category.dart';
import '../model/habit.dart';

class AddHabitPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddHabitPageState();
  }
}

class _AddHabitPageState extends State<AddHabitPage> {
  TextEditingController _startDateController;
  TextEditingController _endDateController;
  TextEditingController _nameController;
  TextEditingController _noteController;

  static final InputDecoration _decoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    labelStyle: const TextStyle(color: Colors.black),
  );

  static final _dateFormatter = DateFormat("MM/dd/yyyy");
  static final _now = DateTime.now();
  static final _firstDate = _now.subtract(const Duration(days: 1));
  static final _lastDate = DateTime(_now.year + 50, _now.month, _now.day);
  final _formKey = GlobalKey<FormState>();

  CategoryModel _category;
  HabitModel _habit;

  @override
  void initState() {
    super.initState();
    _category = null;
    _habit = HabitModel(
      name: "",
      start: _now,
      end: DateTime.now(),
      category: _category,
    )..description = "";

    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _nameController = TextEditingController();
    _noteController = TextEditingController();

    _nameController.text = _habit.name;
    _startDateController.text = _dateFormatter.format(_habit.start);
    _endDateController.text = _dateFormatter.format(_habit.end);
    _noteController.text = _habit.description;

    _noteController.addListener(() {
      _habit.description = _noteController.text;
    });
    _nameController.addListener(() {
      _habit.name = _nameController.text;
    });
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitData>(context, listen: true);

    _category = ModalRoute.of(context).settings.arguments as CategoryModel;
    _habit.category = _category;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            const Text("New habit"),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 21),
              child: Icon(
                _category.icon,
                color: _category.color,
                size: 21,
              ),
            )
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.black),
          onPressed: () => cancel(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 21, right: 21, top: 12, bottom: 7),
              child: Card(
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, top: 7, bottom: 7),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  controller: _nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Habit name can't be empty";
                                    }
                                    return null;
                                  },
                                  decoration: _decoration.copyWith(
                                    labelText: "Habit Name",
                                    errorStyle: TextStyle(color: Colors.red),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () {
                                        _nameController.text = "";
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    onTap: () async {
                                      final pickedStartDate =
                                          await showDatePicker(
                                        context: context,
                                        firstDate: _firstDate,
                                        lastDate: _lastDate,
                                        initialDate: _habit.start,
                                      );
                                      if (pickedStartDate != null) {
                                        _habit.start = pickedStartDate;
                                        _startDateController.text =
                                            _dateFormatter
                                                .format(pickedStartDate);
                                        if (_habit.start.isAfter(_habit.end)) {
                                          _habit.end = _habit.start;
                                          _endDateController.text =
                                              _dateFormatter.format(_habit.end);
                                        }
                                      }
                                    },
                                    readOnly: true,
                                    controller: _startDateController,
                                    decoration: _decoration.copyWith(
                                        labelText: "Start Date",
                                        suffixIcon: null),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    readOnly: true,
                                    controller: _endDateController,
                                    onTap: () async {
                                      final pickedEndDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: _habit.end,
                                        firstDate: _habit.start,
                                        lastDate: _lastDate,
                                      );

                                      if (pickedEndDate != null) {
                                        _endDateController.text = _dateFormatter
                                            .format(pickedEndDate);
                                        _habit.end = pickedEndDate;
                                      }
                                    },
                                    decoration: _decoration.copyWith(
                                        labelText: "End Date",
                                        suffixIcon: null),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        RepeateInputFormField(
                          autovalidate: true,
                          onSaved: (rec) {
                            _habit.recurrence = rec.getRecurrenceRule();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  maxLines: 4,
                                  controller: _noteController,
                                  decoration: _decoration.copyWith(
                                      labelText: "Note",
                                      alignLabelWithHint: true),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 27),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: RaisedButton(
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          habitProvider.add(_habit);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text("Add"),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: RaisedButton(
                                      onPressed: () {},
                                      child: const Text("Cancel"),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool cancel(BuildContext context) => Navigator.of(context).pop();
}

class RepeateInputFormField extends FormField<RepeatRecursionModel> {
  RepeateInputFormField(
      {FormFieldSetter<RepeatRecursionModel> onSaved,
      bool autovalidate = false})
      : super(
            initialValue: RepeatRecursionModel(
                term: "Day",
                interval: 1,
                date: DateTime.now(),
                time: TimeOfDay.now(),
                byDay: []),
            onSaved: onSaved,
            validator: (recurssion) {
              String message;

              if (recurssion.interval <= 0) {
                message = "Invalid repeate interval.";
              }

              if (recurssion.term.compareTo("Week") == 0 &&
                  recurssion.byDay.isEmpty) {
                message = "Please pick at least one week day.";
              }

              return message;
            },
            autovalidate: autovalidate,
            builder: (state) {
              return Column(
                children: <Widget>[
                  RepeateInputFormWidget(
                    onUpdate: (value) {
                      state.didChange(value);
                    },
                    intial: state.value,
                  ),
                  Visibility(
                    visible: state.errorText != null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: Row(
                        children: <Widget>[
                          Text(
                            state.errorText ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            });
}

class RepeateInputFormWidget extends StatefulWidget {
  RepeateInputFormWidget(
      {@required Function(RepeatRecursionModel) onUpdate,
      @required RepeatRecursionModel intial})
      : _onUpdate = onUpdate,
        _intial = intial;

  static final InputDecoration _decoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    labelStyle: const TextStyle(color: Colors.black),
  );
  _RepeateInputFormWidgetState _state;

  Function(RepeatRecursionModel) _onUpdate;
  RepeatRecursionModel _intial;
  @override
  _RepeateInputFormWidgetState createState() {
    return _RepeateInputFormWidgetState();
  }

  String getRecurrenceRule() {
    return _state.getRecurrenceRule();
  }

  String validate() {
    return _state.validat();
  }
}

class RepeatRecursionModel {
  static final DateFormat _dateFormatter = DateFormat("MM/dd/yyyy");
  RepeatRecursionModel(
      {this.interval, this.term, this.time, this.date, this.byDay = const []});

  int interval;
  String term;
  TimeOfDay time;
  DateTime date;
  List<String> byDay;

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  String getRecurrenceRule() {
    String freq = "";
    switch (term) {
      case "Day":
        freq =
            "RRULE:FREQ=DAILY;TIME=${formatTimeOfDay(time)};INTERVAL=${interval}";
        break;
      case "Week":
        freq =
            "RRULE:FREQ=WEEKLY;TIME=${formatTimeOfDay(time)};BYDAY=${byDay.join(',')};INTERVAL=${interval}";
        break;
      case "Year":
        freq =
            "RRULE:FREQ=YEARLY;TIME=${formatTimeOfDay(time)};BYDATE=${_dateFormatter.format(date)}";
        break;
      case "Month":
        freq =
            "RRULE:FREQ=MONTHLY;TIME=${formatTimeOfDay(time)};BYDATE=${_dateFormatter.format(date)}";
        break;
      case "Last Day of a Month":
        freq = "RRULE:FREQ=MONTHLY;TIME=${formatTimeOfDay(time)};BYDATE=LAST";
        break;
    }
    return freq;
  }
}

class _RepeateInputFormWidgetState extends State<RepeateInputFormWidget> {
  static final _now = DateTime.now();
  static final _firstDate = _now.subtract(const Duration(days: 1));
  static final _lastDate = DateTime(_now.year + 50, _now.month, _now.day);
  static final DateFormat _timeFormatter = DateFormat.jm();
  static final DateFormat _dateFormatter = DateFormat("MM/dd/yyyy");
  TextEditingController _repeatTermController;
  TextEditingController _timeController;
  TextEditingController _dateController;
  RepeatRecursionModel recurssion;

  @override
  void initState() {
    super.initState();
    widget._state = this;

    recurssion = widget._intial;

    _repeatTermController = TextEditingController();
    _dateController = TextEditingController();
    _repeatTermController.addListener(() {
      recurssion.interval = int.parse(_repeatTermController.text);
    });
    _repeatTermController.text = recurssion.interval.toString();
    _timeController = TextEditingController();
    _timeController.text = formatTimeOfDay(recurssion.time);
    _dateController.text = _dateFormatter.format(recurssion.date);
  }

  @override
  void dispose() {
    super.dispose();
    _repeatTermController.dispose();
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InputDecorator(
        decoration: RepeateInputFormWidget._decoration
            .copyWith(labelText: "Repeats Every"),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _repeatTermController,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: false),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 16),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3))),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Theme(
                    data: ThemeData(
                        canvasColor:
                            Provider.of<TrackitThemeData>(context).colorTwo,
                        primaryColor:
                            Provider.of<TrackitThemeData>(context).colorOne,
                        accentColor:
                            Provider.of<TrackitThemeData>(context).colorOne,
                        hintColor:
                            Provider.of<TrackitThemeData>(context).colorOne),
                    child: InputDecorator(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 16),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3))),
                      child: DropdownButton<String>(
                          focusColor:
                              Provider.of<TrackitThemeData>(context).colorTwo,
                          value: recurssion.term,
                          isExpanded: true,
                          items: <String>[
                            'Day',
                            'Week',
                            'Month',
                            "Last Day of a Month",
                            'Year'
                          ].map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              recurssion.term = value;
                              widget._onUpdate(recurssion);
                            });
                          }),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          readOnly: true,
                          controller: _timeController,
                          onTap: () async {
                            final time = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            if (time != null) {
                              recurssion.time = time;
                              _timeController.text =
                                  formatTimeOfDay(recurssion.time);
                            }
                            widget._onUpdate(recurssion);
                          },
                          decoration: InputDecoration(
                            labelText: "Time",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        recurssion.term == "Month" || recurssion.term == "Year",
                    child: Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            readOnly: true,
                            controller: _dateController,
                            onTap: () async {
                              final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: _firstDate,
                                  lastDate: _lastDate);

                              if (date != null) {
                                _dateController.text =
                                    _dateFormatter.format(date);
                              }

                              widget._onUpdate(recurssion);
                            },
                            decoration: InputDecoration(
                              labelText: "Date",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              labelStyle: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: recurssion.term == "Week",
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <String, String>{
                      "MO": "M",
                      "TU": "T",
                      "WE": "W",
                      "TH": "T",
                      "FR": "F",
                      "SA": "S",
                      "SU": "S"
                    }
                        .entries
                        .map((entry) => Expanded(
                              child: CircularButton(
                                  value: entry.value,
                                  onSelect: () {
                                    recurssion.byDay.add(entry.key);
                                    widget._onUpdate(recurssion);
                                  },
                                  onUnselect: () {
                                    recurssion.byDay.remove(entry.key);
                                    widget._onUpdate(recurssion);
                                  }),
                            ))
                        .toList()),
              ),
            )
          ],
        ),
      ),
    );
  }

  String validat() {
    String message = null;

    if (recurssion.interval <= 0) {
      message = "Invalid repeate interval.";
    }

    if (recurssion.term.compareTo("Week") == 0 && recurssion.byDay.isEmpty) {
      message = "Please pick at least one week day.";
    }

    return message;
  }

  String getRecurrenceRule() {
    String freq = "";
    switch (recurssion.term) {
      case "Day":
        freq =
            "RRULE:FREQ=DAILY;TIME=${formatTimeOfDay(recurssion.time)};INTERVAL=${recurssion.interval}";
        break;
      case "Week":
        freq =
            "RRULE:FREQ=WEEKLY;TIME=${formatTimeOfDay(recurssion.time)};BYDAY=${recurssion.byDay.join(',')};INTERVAL=${recurssion.interval}";
        break;
      case "Year":
        freq =
            "RRULE:FREQ=YEARLY;TIME=${formatTimeOfDay(recurssion.time)};BYDATE=${_dateFormatter.format(recurssion.date)}";
        break;
      case "Month":
        freq =
            "RRULE:FREQ=MONTHLY;TIME=${formatTimeOfDay(recurssion.time)};BYDATE=${_dateFormatter.format(recurssion.date)}";
        break;
      case "Last Day of a Month":
        freq =
            "RRULE:FREQ=MONTHLY;TIME=${formatTimeOfDay(recurssion.time)};BYDATE=LAST";
        break;
    }
    return freq;
  }
}

class CircularButton extends StatefulWidget {
  const CircularButton({String value, Function onSelect, Function onUnselect})
      : _label = value,
        _onSelect = onSelect,
        _onUnselect = onUnselect;

  final Function _onSelect;
  final Function _onUnselect;
  final String _label;

  @override
  _CircularButtonState createState() => _CircularButtonState();
}

class _CircularButtonState extends State<CircularButton> {
  bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ClipOval(
        child: Material(
          elevation: 3,
          color: _isSelected
              ? Provider.of<TrackitThemeData>(context).colorThree
              : Provider.of<TrackitThemeData>(context).colorOne,
          child: SizedBox(
            height: 36,
            child: InkWell(
              splashColor: Provider.of<TrackitThemeData>(context).colorThree,
              onTap: () {
                setState(() {
                  _isSelected = !_isSelected;
                  if (_isSelected) {
                    widget._onSelect();
                  } else {
                    widget._onUnselect();
                  }
                });
              }, // inkwell color
              child: Center(child: Text(widget._label)),
            ),
          ),
        ),
      ),
    );
  }
}
