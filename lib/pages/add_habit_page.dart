import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  String _recurssion;

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

    final repeatInputField = RepeatInputField();

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
                        repeatInputField,
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
                                        final rule = repeatInputField
                                            .getRecurrenceRule();
                                        if(_formKey.currentState.validate()){
                                           //TODO call form validator on repeate input 
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
  _RepeatInputFieldState _state;
  RepeatInputField();

  @override
  _RepeatInputFieldState createState() {
    return _RepeatInputFieldState();
  }

  String getRecurrenceRule() {
    return _state.getRecurrenceRule();
  }

  String validate() {
    return _state.validat();
  }
}

class _RepeatInputFieldState extends State<RepeatInputField> {
  static final _now = DateTime.now();
  static final _firstDate = _now.subtract(const Duration(days: 1));
  static final _lastDate = DateTime(_now.year + 50, _now.month, _now.day);
  static final DateFormat _timeFormatter = DateFormat.jm();
  static final DateFormat _dateFormatter = DateFormat("MM/dd/yyyy");
  TextEditingController _repeatTermController;
  TextEditingController _timeController;
  TextEditingController _dateController;

  int _repeatInterval;
  String _repeatTerm;
  TimeOfDay _time;
  DateTime _date;
  List<String> _byDay;

  @override
  void initState() {
    super.initState();
    widget._state = this;
    _byDay = [];
    _repeatTerm = "Day";
    _repeatInterval = 1;
    _repeatTermController = TextEditingController();
    _dateController = TextEditingController();
    _time = TimeOfDay.now();
    _date = DateTime.now();
    _repeatTermController.addListener(() {
      _repeatInterval = int.parse(_repeatTermController.text);
    });
    _repeatTermController.text = _repeatInterval.toString();
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
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <String, String>{
                        "MO": "M",
                        "TH": "T",
                        "WE": "W",
                        "TH": "T",
                        "FR": "F",
                        "SA": "S",
                        "SU": "S"
                      }
                          .entries
                          .map((entry) => CircularButton(
                              value: entry.value,
                              onSelect: () {
                                _byDay.add(entry.key);
                              },
                              onUnselect: () {
                                _byDay.remove(entry.key);
                              }))
                          .toList()),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String validat() {
    String message = null;

    if (_repeatInterval <= 0) {
      message = "Invalid repeate interval.";
    }

    if (_repeatTerm.compareTo("Week") == 0 && _byDay.isEmpty) {
      message = "Please pick at least one week day.";
    }

    return message;
  }

  String getRecurrenceRule() {
    String freq = "";
    switch (_repeatTerm) {
      case "Day":
        freq =
            "RRULE:FREQ=DAILY;TIME=${formatTimeOfDay(_time)};INTERVAL=${_repeatInterval}";
        break;
      case "Week":
        freq =
            "RRULE:FREQ=WEEKLY;TIME=${formatTimeOfDay(_time)};BYDAY=${_byDay.join(',')};INTERVAL=${_repeatInterval}";
        break;
      case "Year":
        freq =
            "RRULE:FREQ=YEARLY;TIME=${formatTimeOfDay(_time)};;BYDATE=${_dateFormatter.format(_date)}";
        break;
      case "Month":
        freq =
            "RRULE:FREQ=MONTHLY;TIME=${formatTimeOfDay(_time)};BYDATE=${_dateFormatter.format(_date)}";
        break;
      case "Last Day of a Month":
        freq = "RRULE:FREQ=MONTHLY;TIME=${formatTimeOfDay(_time)};BYDATE=LAST";
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
          elevation: 5,
          color:
              _isSelected ? const Color(0xFFFC9C35) : const Color(0xFFE0D4B9),
          child: InkWell(
            splashColor: const Color(0xFFFC9C35),
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
            child: SizedBox(
                width: 41,
                height: 41,
                child: Center(child: Text(widget._label))),
          ),
        ),
      ),
    );
  }
}
