import 'dart:html';

import 'package:flutter/material.dart';
import 'package:scheduler/customTemplates/export.dart';

enum ScreenSize {small, large}

class ResponsiveWidget {
  //Large screen is any screen whose width is more than 1200 pixels
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  //Small screen is any screen whose width is less than 800 pixels
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }
  
  static ScreenSize getScreenSize(BuildContext context) {
    if (MediaQuery.of(context).size.width > 1200) {
      return ScreenSize.large;
    } else if(MediaQuery.of(context).size.width < 800) {
      return ScreenSize.small;
    }
  }

  static EdgeInsets layoutPadding(ScreenSize size) {
    switch (size) {
      case ScreenSize.small:
        return EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0);
        break;
      default:
    }
  }

  // No medium screen for now

  //Medium screen is any screen whose width is less than 1200 pixels,
  //and more than 800 pixels
  // static bool isMediumScreen(BuildContext context) {
  //   return MediaQuery.of(context).size.width > 800 &&
  //   MediaQuery.of(context).size.width < 1200;
  // }  
}