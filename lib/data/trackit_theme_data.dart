import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TrackitThemeData extends ChangeNotifier {
  Color _colorTwo = const Color(0xFFF2EBDA);
  Color _colorOne = const Color(0xFFE0D4B9);
  Color _colorThree = const Color(0xFFFC9C35);
  Color _colorThreeDisabled = const Color(0x88FC9C35);

  Color _colorOneText = Colors.black;

  Color get colorTwo => _colorTwo;
  Color get colorOne => _colorOne;
  Color get colorThree => _colorThree;
  Color get colorThreeDisabled => _colorThreeDisabled;
  Color get colorOneText => _colorThreeDisabled;
}
