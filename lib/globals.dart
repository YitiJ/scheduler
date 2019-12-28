import 'package:flutter/material.dart';

double _height;
double _width;

enum Screen {small, large}

class ScreenData extends Object {
  static void setHeightWidth(MediaQueryData data) {
    _height = data.size.height;
    _width = data.size.width;
    getSize();
  }

  static Screen getSize() {
    if (_width > 1200) {
      print('large');
      return Screen.large;
    // } else if(_width < 800) {
    } else if(_width <= 1200) {
      print('small');
      return Screen.small;
    }
  }
}