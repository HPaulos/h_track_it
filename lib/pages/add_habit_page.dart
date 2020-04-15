import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/category.dart';
import '../model/habit.dart';

class AddHabitPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddHabitPageState();
  }
}

class _AddHabitPageState extends State<AddHabitPage> {
  CategoryModel _category;

  HabitModel _habit;
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

  @override
  void initState() {
    super.initState();
    _category = null;
    _habit = HabitModel(
        name: "",
        start: _now,
        end: DateTime.now(),
        category: _category,
        upcomming: null,
        last: null)
      ..description = "";

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
    _category = ModalRoute.of(context).settings.arguments as CategoryModel;
    _habit.category = _category;

    return Scaffold(
      backgroundColor: const Color(0xFFE0D4B9),
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
                color: const Color(0xFFF2EBDA),
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
                        RepeatInputField(),
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
                                      color: const Color(0xFFE0D4B9),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {

                                          
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
                                      color: const Color(0xFFE0D4B9),
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

class RepeatInputField extends StatefulWidget {
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

  @override
  _RepeatInputFieldState createState() => _RepeatInputFieldState();
}

class _RepeatInputFieldState extends State<RepeatInputField> {
  static final _now = DateTime.now();
  static final _firstDate = _now.subtract(const Duration(days: 1));
  static final _lastDate = DateTime(_now.year + 50, _now.month, _now.day);
  final DateFormat _timeFormatter = DateFormat.jm();
  final DateFormat _dateFormatter = DateFormat("MM/dd/yyyy");
  TextEditingController _repeatTermController;
  TextEditingController _timeController;
  TextEditingController _dateController;

  int _repeatCount;
  String _repeatTerm;
  TimeOfDay _time;
  DateTime _date;

  @override
  void initState() {
    super.initState();
    _repeatTerm = "Day";
    _repeatCount = 1;
    _repeatTermController = TextEditingController();
    _dateController = TextEditingController();
    _time = TimeOfDay.now();
    _date = DateTime.now();
    _repeatTermController.addListener(() {
      _repeatCount = int.parse(_repeatTermController.text);
    });
    _repeatTermController.text = _repeatCount.toString();
    _timeController = TextEditingController();
    _timeController.text = formatTimeOfDay(_time);
    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    super.dispose();
    _repeatTermController.dispose();
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InputDecorator(
        decoration:
            RepeatInputField._decoration.copyWith(labelText: "Repeats Every"),
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
                        canvasColor: const Color(0xFFF2EBDA),
                        primaryColor: const Color(0xFFE0D4B9),
                        accentColor: const Color(0xFFE0D4B9),
                        hintColor: const Color(0xFFE0D4B9)),
                    child: InputDecorator(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 16),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3))),
                      child: DropdownButton<String>(
                          focusColor: const Color(0xFFF2EBDA),
                          value: _repeatTerm,
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
                              _repeatTerm = value;
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
                              _time = time;
                              _timeController.text = formatTimeOfDay(_time);
                            }
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
                    visible: _repeatTerm == "Month" || _repeatTerm == "Year",
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
              visible: _repeatTerm == "Week",
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  children: ["M", "T", "W", "T", "F", "S", "S"]
                      .map((day) => Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: CircularButton(day))))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CircularButton extends StatefulWidget {
  const CircularButton(String label) : _label = label;

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
    return MaterialButton(
      elevation: 5,
      padding: const EdgeInsets.all(3),
      shape: const CircleBorder(),
      color: _isSelected ? const Color(0xFFFC9C35) : const Color(0xFFE0D4B9),
      onPressed: () {
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: Center(child: Text(widget._label)),
    );
  }
}
