import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/trackit_theme_data.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget(this._searchFocusNode, this._searchController, {Key key})
      : super(key: key);

  final FocusNode _searchFocusNode;
  final TextEditingController _searchController;

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool _hasFocus;

  @override
  void initState() {
    _hasFocus = widget._searchFocusNode?.hasFocus;
    widget._searchFocusNode.addListener(() {
      setState(() {
        _hasFocus = widget._searchFocusNode?.hasFocus;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(23),
      color: Provider.of<TrackitThemeData>(context).colorTwo,
      elevation: 5,
      child: Container(
        height: 41,
        child: Theme(
          data: ThemeData(
              primaryColor: Provider.of<TrackitThemeData>(context)
                  .colorTwo
                  .withOpacity(0.5),
              focusColor: Provider.of<TrackitThemeData>(context).colorThree),
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Provider.of<TrackitThemeData>(context)
                  .colorThree
                  .withOpacity(0.5),
            ),
            child: TextField(
              controller: widget._searchController,
              focusNode: widget._searchFocusNode,
              decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    fontFamily: "Roboto",
                  ),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: _hasFocus
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.redAccent,
                          ),
                          color:
                              Provider.of<TrackitThemeData>(context).colorThree,
                          onPressed: () {
                            widget._searchFocusNode.unfocus();
                            widget._searchController.clear();
                          })
                      : null,
                  border: InputBorder.none),
              style: const TextStyle(
                fontSize: 16,
                fontFamily: "Roboto",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
