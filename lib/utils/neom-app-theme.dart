// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:ui';

import 'package:flutter/material.dart';

class NeomAppTheme {

  static final neomBoxDecoration = BoxDecoration(
    color: NeomAppColor.darkViolet.withOpacity(0.6),
  );

  static String getLeadingHeroTag(int index) {
    return "LEADING_HERO_TAG_" + index.toString();
  }
  static final Size appBarHeight = Size.fromHeight(50.0);

  static final kHintTextStyle = TextStyle(
    color: Colors.white54,
    fontFamily: NeomAppTheme.fontFamily,
  );

  static final kLabelStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: NeomAppTheme.fontFamily,
  );

  static final kBoxDecorationStyle = BoxDecoration(
    color: Color(0xFF6CA8F1).withOpacity(0.3),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  static const double appPadding = 20.0;
  static final double chipsFontSize = 25;

  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static const double elevationFAB = 10.0;

  static const String fontFamily = "Open-Sans";
  static const double aspectRatio = 16/9;

}

class NeomAppColor{

  static final Color darkViolet = Color.fromRGBO(79, 25, 100, 1);
  static final Color deepDarkViolet = Color.fromRGBO(79, 25, 100, 1).withOpacity(0.6);
  static final Color bottomNavigationBar = darkViolet.withOpacity(0.3);
  static final Color drawer = darkViolet.withOpacity(0.6);
  static final Color appBar = darkViolet.withOpacity(0.3);

  static final Color secondary = Color(0xff14171A);
  static final Color lightGrey = Color(0xffAAB8C2);
  static final Color ceriseRed = Color.fromRGBO(224, 36, 94, 1.0);
  static final Color mystic = Color.fromRGBO(230, 236, 240, 1.0);
  static final Color bondiBlue = Color.fromRGBO(0, 132, 180, 1.0);
  static final Color dodgetBlue = Color.fromRGBO(29, 162, 240, 1.0);

}

