import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
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
    final categoriesProvider = Provider.of<CategoryData>(context, listen: true);
    final model = ModalRoute.of(context).settings.arguments;
    Widget form;

    if (model != null) {
      final cModel = model as CategoryModel;
      form = AddCategoryForm(
        category: cModel,
      );
    } else {
      form = AddCategoryForm();
    }

    return Scaffold(
        backgroundColor: const Color(0xFFE0D4B9),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.clear, color: Colors.black),
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
    final categoriesProvider = Provider.of<CategoryData>(context, listen: true);

    return ListView(
      children: <Widget>[
        Container(
          padding:
              const EdgeInsets.only(left: 21, right: 21, top: 12, bottom: 7),
          child: Card(
            color: const Color(0xFFF2EBDA),
            child: Container(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 7, bottom: 7),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 12, right: 7),
                          child: Text(
                            "Name",
                            style: TextStyle(fontSize: 19),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(fontSize: 19),
                            decoration: const InputDecoration(
                              hintText: "Enter Group Name",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 12),
                    child: Row(
                      children: <Widget>[
                        const Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(
                              "Pick an Icon and Color",
                              style:
                                  TextStyle(fontSize: 19, color: Colors.black),
                            ),
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
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Scrollbar(
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: SizedBox(
                          height: 180,
                          child: SingleChildScrollView(
                              child: IconPicker(
                            colorCode: _color,
                            onSelected: (icon) {
                              setState(() {
                                _icon = icon;
                              });
                            },
                          )),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Scrollbar(
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: SizedBox(
                          height: 180,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SingleChildScrollView(
                              child: ColorPicker(
                                selected: _color,
                                onUpdate: (col) {
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 27, right: 27),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: RaisedButton(
                              disabledColor: const Color(0xFFE0D4B9),
                              color: const Color(0xFFE0D4B9),
                              onPressed: () {
                                if (_name == null || _name.isEmpty) {
                                  setState(showErrorMessage);
                                } else {
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
                              color: const Color(0xFFE0D4B9),
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
      ],
    );
  }

  bool goBack(BuildContext context) => Navigator.of(context).pop();

  Future<void> showErrorMessage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(21),
          contentPadding: const EdgeInsets.all(21),
          backgroundColor: const Color(0xFFE0D4B9),
          contentTextStyle: const TextStyle(fontSize: 21, color: Colors.black),
          title: const Text('Invalid Input'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Please provide the new group name.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: const Color(0xFFE0D4B9),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Okay',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}

@immutable
class ColorPicker extends StatefulWidget {
  ColorPicker({@required this.onUpdate, @required this.selected});

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

  final Function(Color color) onUpdate;
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
                  padding: const EdgeInsets.all(7.0),
                  child: ClipOval(
                    child: Container(
                      color: color,
                      child: InkWell(
                        splashColor: const Color(0xFFE0D4B9),
                        onTap: () {
                          widget.onUpdate(color);
                          setState(() {
                            widget.selected = color;
                          });
                        },
                        child: color == widget.selected
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
      {@required this.colorCode,
      @required this.selected,
      @required this.onSelected});

  final Color colorCode;
  final Function(IconData icon) onSelected;
  IconData selected;

  static List<IconData> icons = [
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
                  padding: const EdgeInsets.all(7.0),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        widget.selected = icon;
                        widget.onSelected(widget.selected);
                      });
                    },
                    icon: Icon(
                      icon,
                      size: widget.selected == icon ? 54 : 41,
                      color: widget.selected == icon
                          ? widget.colorCode
                          : Colors.black,
                    ),
                  ),
                ))
            .toList());
  }
}
