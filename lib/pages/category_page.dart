import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../data/category_data.dart';
import '../model/category.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoryData>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE0D4B9),
      appBar: AppBar(
        leading: Container(),
        actions: const <Widget>[],
        title: const Text("Habit Groups"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: buildCategoryList(categoriesProvider.categories),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF2EBDA),
        unselectedIconTheme: const IconThemeData(color: Color(0x88FC9C35)),
        selectedIconTheme: const IconThemeData(color: Color(0xFFFC9C35)),
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
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/calendar');
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(21),
        child: FloatingActionButton(
          elevation: 12,
          onPressed: () {
            Navigator.pushNamed(context, '/newCategory');
          },
          backgroundColor: const Color(0xFFFC9C35),
          child: const Icon(
            Icons.add,
            size: 27,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildCategoryList(List<CategoryModel> categories) {
    final rows = <Widget>[];

    final length = categories.length;
    for (var i = 0; i < length; i = i + 2) {
      final first = Expanded(child: Category(category: categories[i]));
      final second = length > i + 1
          ? Expanded(child: Category(category: categories[i + 1]))
          : Expanded(child: Container());
      rows.add(Padding(
        padding: const EdgeInsets.only(left: 27, right: 27, bottom: 27),
        child: Row(
          children: <Widget>[first, second],
        ),
      ));
    }

    return Column(
      children: rows,
    );
  }
}

@immutable
class Category extends StatelessWidget {
  Category({@required CategoryModel category, String gotToPage = '/habits'})
      : _category = category,
        _gotToPage = gotToPage;

  final CategoryModel _category;
  final String _gotToPage;

  Offset _tapPosition;

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoryData>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      child: Container(
        height: 100,
        width: 100,
        child: Material(
          elevation: 7,
          shadowColor: const Color(0xFFFC9C35),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(27),
            bottomRight: Radius.circular(27),
            topRight: Radius.circular(27),
            bottomLeft: Radius.circular(27),
          ),
          color: const Color(0xFFF2EBDA),
          child: InkWell(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(27),
              bottomRight: Radius.circular(27),
              topRight: Radius.circular(27),
              bottomLeft: Radius.circular(27),
            ),
            splashColor: const Color(0xFFFC9C35),
            highlightColor: const Color(0xFFFC9C35),
            onTapDown: (details) {
              _tapPosition = details.globalPosition;
            },
            onLongPress: () {
              showPopUpMenu(context, _category, () {
                categoriesProvider.remove(_category);
              }, () {
                Navigator.pushNamed(context, '/newCategory',
                    arguments: _category);
              });
            },
            onTap: () {
              Navigator.pushNamed(context, _gotToPage,
                  arguments: _category);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Icon(
                    _category.icon,
                    size: 41,
                    color: _category.color,
                    semanticLabel: _category.name,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    _category.name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<int> showPopUpMenu(BuildContext context, CategoryModel categoery,
      Function onDelete, Function onEdit) async {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final size = overlay.size;

    return showMenu(
      color: const Color(0xFFF2EBDA),
      elevation: 7,
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & const Size(40, 40), Offset.zero & size),
      items: <PopupMenuEntry<int>>[
        DeleteEditPopUpMenu(
          onDelete: () {
            onDelete();
          },
          onEdit: onEdit,
        )
      ],
    );
  }
}

@immutable
class DeleteEditPopUpMenu extends PopupMenuEntry<int> {
  const DeleteEditPopUpMenu({Function onDelete, Function onEdit})
      : _onDelete = onDelete,
        _onEdit = onEdit;

  final Function _onDelete;
  final Function _onEdit;

  @override
  State<StatefulWidget> createState() {
    return _DeleteEditPopUpMenuState();
  }

  @override
  double get height => 64;

  @override
  bool represents(int value) {
    return value == 1 || value == -1;
  }
}

class _DeleteEditPopUpMenuState extends State<DeleteEditPopUpMenu> {
  static const String message =
      'Are you sure you want to delete this group and all tasks under it';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 41,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: IconButton(
              onPressed: confirmDelete,
              icon: Icon(
                Icons.delete,
                color: Colors.redAccent,
                size: 27,
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () {
                Navigator.pop<int>(context, -1);
                widget._onEdit();
              },
              icon: Icon(
                Icons.edit,
                color: Colors.green,
                size: 27,
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () {
                Navigator.pop<int>(context, -1);
              },
              icon: Icon(
                Icons.cancel,
                color: Colors.lightBlue,
                size: 27,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> confirmDelete() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          titlePadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 21),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 21),
          backgroundColor: const Color(0xFFE0D4B9),
          contentTextStyle: const TextStyle(fontSize: 21, color: Colors.black),
          title: const Text('Confirm Delete'),
          content: SingleChildScrollView(
              child: ListBody(
            children: const <Widget>[
              Text(message),
            ],
          )),
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              onPressed: () {
                widget._onDelete();
                Navigator.of(context).pop();
                Navigator.pop<int>(context, -1);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.black),
              ),
            ),
            FlatButton(
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop<int>(context, -1);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
