import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/trackit_theme_data.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget(this._searchFocusNode, this._searchController, {Key key})
      : super(key: key);

  final FocusNode _searchFocusNode;
  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(23),
      color: Provider.of<TrackitThemeData>(context).colorTwo,
      elevation: 7,
      child: Container(
        height: 40,
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
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                  hintText: "rSearch",
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    fontFamily: "Roboto",
                  ),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: _searchFocusNode.hasFocus
                      ? IconButton(
                          icon: Icon(Icons.cancel),
                          color:
                              Provider.of<TrackitThemeData>(context).colorThree,
                          onPressed: () {
                            _searchFocusNode.unfocus();
                            _searchController.clear();
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
