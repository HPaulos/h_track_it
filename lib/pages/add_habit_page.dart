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
  HabitModel habit;
  CategoryModel _category;
  TextEditingController _startDateController;
  TextEditingController _endDateController;
  TextEditingController _nameController;

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
    labelStyle: TextStyle(color: Colors.black),
  );

  static final DateFormat _dateFormat = DateFormat("MM/dd/yyyy");
  static final _now = DateTime.now();
  static final _firstDate = _now.subtract(const Duration(days: 1));
  static final _lastDate = DateTime(_now.year + 20, _now.month, _now.day);

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _nameController = TextEditingController();
    _category = null;
    habit = HabitModel(
        name: "",
        start: _now,
        end: DateTime.now(),
        category: _category,
        upcomming: null,
        last: null);
    _startDateController.text = _dateFormat.format(habit.start);
    _endDateController.text = _dateFormat.format(habit.end);
    _nameController.text = habit.name;
  }

  @override
  void dispose() {
    _startDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _category = ModalRoute.of(context).settings.arguments as CategoryModel;
    habit.category = _category;
    return Scaffold(
      backgroundColor: const Color(0xFFE0D4B9),
      appBar: AppBar(
        title: Text("New ${_category.name} habit"),
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.black),
          onPressed: () => cancel(context),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 21, right: 21, top: 12, bottom: 7),
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
                                  // validation logic
                                },
                                decoration: _decoration.copyWith(
                                  labelText: "Habit Name",
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
                                      initialDate: habit.start,
                                    );
                                    if (pickedStartDate != null) {
                                      habit.start = pickedStartDate;
                                      _startDateController.text =
                                          _dateFormat.format(pickedStartDate);
                                      if (habit.start.isAfter(habit.end)) {
                                        habit.end = habit.start;
                                        _endDateController.text =
                                            _dateFormat.format(habit.end);
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
                                    final pickedEndDate = await showDatePicker(
                                      context: context,
                                      initialDate: habit.end,
                                      firstDate: habit.start,
                                      lastDate: _lastDate,
                                    );

                                    if (pickedEndDate != null) {
                                      _endDateController.text =
                                          _dateFormat.format(pickedEndDate);
                                      habit.end = pickedEndDate;
                                    }
                                  },
                                  decoration: _decoration.copyWith(
                                      labelText: "End Date", suffixIcon: null),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  bool cancel(BuildContext context) => Navigator.of(context).pop();
}
