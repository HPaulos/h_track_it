import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../data/trackit_theme_data.dart';
import '../data/category_data.dart';
import '../model/category.dart';

class AddCategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddCategoryPageState();
  }
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  @override
  Widget build(BuildContext context) {
    final model = ModalRoute.of(context).settings.arguments;
    Widget form;

    if (model != null) {
      final cModel = model as CategoryModel;
      form = AddCategoryForm(
        category: cModel,
      );
    } else {
      form = const AddCategoryForm();
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => goBack(context),
          ),
          title: const Text("New Group"),
        ),
        body: form);
  }

  bool goBack(BuildContext context) => Navigator.of(context).pop();
}

class AddCategoryForm extends StatefulWidget {
  const AddCategoryForm({this.category});

  final CategoryModel category;

  @override
  State<StatefulWidget> createState() {
    return AddCategoryFormState();
  }
}

class AddCategoryFormState extends State<AddCategoryForm> {
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
  final _formKey = GlobalKey<FormState>();

  String _name;
  Color _color;
  IconData _icon;
  TextEditingController _controller;
  bool _isUpdating;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      _name = _controller.text;
    });
    if (widget.category != null) {
      _isUpdating = true;
      _name = widget.category.name;
      _color = widget.category.color;
      _icon = widget.category.icon;
    } else {
      _isUpdating = false;
      _icon = IconPicker.icons[0];
      _color = ColorPicker.colors[0];
    }
    _controller.text = _name;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider =
        Provider.of<CategoryData>(context, listen: false);

    return ListView(
      children: <Widget>[
        Container(
          padding:
              const EdgeInsets.only(left: 21, right: 21, top: 12, bottom: 7),
          child: Form(
            key: _formKey,
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
                              child: Material(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Group Name can't be empty.";
                                } else {
                                  if (!_isUpdating &&
                                      categoriesProvider
                                          .searchCategoryByName(_name)) {
                                    return "Name is already in use by another group.";
                                  }

                                  if (_isUpdating &&
                                      widget.category.name.toLowerCase() !=
                                          _name.toLowerCase() &&
                                      categoriesProvider.searchCategoryByName(
                                          _name.toLowerCase())) {
                                    return "Name is already in use by another group.";
                                  }

                                  return null;
                                }
                              },
                              controller: _controller,
                              decoration: _decoration.copyWith(
                                labelText: "Group Name",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    _controller.text = "";
                                  },
                                ),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: InputDecorator(
                          decoration: _decoration.copyWith(
                            labelText: "Pick Icon and Color for the group",
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: <Widget>[
                                    const Flexible(
                                      child: Text(
                                        "Icon and Color Selected",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Icon(
                                        _icon,
                                        size: 27,
                                        color: _color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: InputDecorator(
                                  decoration: _decoration.copyWith(
                                      labelText: "Group Icon"),
                                  child: Scrollbar(
                                    child: SizedBox(
                                      height: 120,
                                      child: SingleChildScrollView(
                                          child: IconPicker(
                                        selected: _icon,
                                        color: _color,
                                        onSelect: (icon) {
                                          setState(() {
                                            _icon = icon;
                                          });
                                        },
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: InputDecorator(
                                  decoration: _decoration.copyWith(
                                      labelText: "Group Color"),
                                  child: Scrollbar(
                                    child: SizedBox(
                                      height: 120,
                                      child: SingleChildScrollView(
                                        child: ColorPicker(
                                          selected: _color,
                                          onSelect: (col) {
                                            setState(() {
                                              _color = col;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 27, right: 27),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: RaisedButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    if (_isUpdating) {
                                      categoriesProvider.update(
                                          widget.category,
                                          CategoryModel(
                                              color: _color,
                                              name: _name,
                                              icon: _icon));
                                    } else {
                                      categoriesProvider.add(CategoryModel(
                                          color: _color,
                                          name: _name,
                                          icon: _icon));
                                    }
                                    _name = "";
                                    _color = ColorPicker.colors[0];
                                    _icon = IconPicker.icons[0];
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: _isUpdating
                                    ? const Text("Update")
                                    : const Text("Add"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: RaisedButton(
                                onPressed: () {
                                  goBack(context);
                                },
                                child: const Text("Cancel"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool goBack(BuildContext context) => Navigator.of(context).pop();
}

@immutable
class ColorPicker extends StatefulWidget {
  ColorPicker({@required this.onSelect, @required this.selected});

  static List<Color> colors = [
    Colors.green,
    Colors.greenAccent,
    Colors.blue,
    Colors.blueAccent,
    Colors.blueGrey,
    Colors.red,
    Colors.redAccent,
    Colors.amber,
    Colors.yellow,
    Colors.yellowAccent,
    Colors.amberAccent,
    Colors.brown,
    Colors.teal,
    Colors.tealAccent,
    Colors.cyan,
    Colors.cyanAccent,
    Colors.deepOrange,
    Colors.orangeAccent,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    Colors.indigo,
    Colors.indigoAccent,
    Colors.white12
  ];

  final Function(Color color) onSelect;
  Color selected;

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: ColorPicker.colors
            .map((color) => Padding(
                  padding: const EdgeInsets.all(7),
                  child: ClipOval(
                    child: Container(
                      color: color,
                      child: InkWell(
                        splashColor:
                            Provider.of<TrackitThemeData>(context).colorOne,
                        onTap: () {
                          widget.onSelect(color);
                          setState(() {
                            widget.selected = color;
                          });
                        },
                        child: widget.selected == color
                            ? const SizedBox(width: 54, height: 54)
                            : const SizedBox(width: 41, height: 41),
                      ),
                    ),
                  ),
                ))
            .toList());
  }
}

@immutable
class IconPicker extends StatefulWidget {
  IconPicker(
      {@required Color color,
      @required IconData selected,
      @required Function(IconData icon) onSelect})
      : this._color = color,
        this._onSelect = onSelect,
        this._selected = selected;

  final Color _color;
  final Function(IconData icon) _onSelect;
  IconData _selected;

  static List<IconData> icons = [
    FontAwesomeIcons.accessibleIcon,
    FontAwesomeIcons.solidHeart,
    FontAwesomeIcons.lightbulb,
    FontAwesomeIcons.bookOpen,
    FontAwesomeIcons.running,
    FontAwesomeIcons.walking,
    FontAwesomeIcons.prescription,
    FontAwesomeIcons.medal,
    FontAwesomeIcons.restroom,
    FontAwesomeIcons.water,
    FontAwesomeIcons.bath,
    FontAwesomeIcons.shower,
    FontAwesomeIcons.podcast,
    FontAwesomeIcons.coffee,
    FontAwesomeIcons.phone,
    FontAwesomeIcons.bible,
    FontAwesomeIcons.quran,
    FontAwesomeIcons.play,
    FontAwesomeIcons.gift,
    FontAwesomeIcons.hammer,
    FontAwesomeIcons.chrome,
    FontAwesomeIcons.brush,
    FontAwesomeIcons.restroom,
    FontAwesomeIcons.code,
    FontAwesomeIcons.handsWash,
    FontAwesomeIcons.key,
    FontAwesomeIcons.youtube,
    FontAwesomeIcons.calendar,
    FontAwesomeIcons.layerGroup,
    FontAwesomeIcons.calculator,
    FontAwesomeIcons.circleNotch,
    FontAwesomeIcons.hotel,
    FontAwesomeIcons.laugh,
    FontAwesomeIcons.taxi,
    FontAwesomeIcons.baby,
    FontAwesomeIcons.bars,
    FontAwesomeIcons.batteryEmpty,
    FontAwesomeIcons.camera,
    FontAwesomeIcons.church,
    FontAwesomeIcons.mosque,
    FontAwesomeIcons.pray,
    FontAwesomeIcons.xbox,
    FontAwesomeIcons.facebook,
    FontAwesomeIcons.amazon,
    FontAwesomeIcons.inbox,
    FontAwesomeIcons.running,
    FontAwesomeIcons.chair,
    FontAwesomeIcons.dog,
    FontAwesomeIcons.cat,
    FontAwesomeIcons.kiss,
    FontAwesomeIcons.music,
    FontAwesomeIcons.smile,
    FontAwesomeIcons.bed,
    FontAwesomeIcons.car,
    FontAwesomeIcons.clock
  ];

  @override
  _IconPickerState createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: IconPicker.icons
            .map((icon) => Padding(
                  padding: const EdgeInsets.all(7),
                  child: ClipOval(
                    child: InkWell(
                        onTap: () {
                          widget._onSelect(icon);
                          setState(() {
                            widget._selected = icon;
                          });
                        },
                        child: Icon(
                          icon,
                          size: icon == widget._selected ? 54 : 41,
                          color: widget._color,
                        )),
                  ),
                ))
            .toList());
  }
}
