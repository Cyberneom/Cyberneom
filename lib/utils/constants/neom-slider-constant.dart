import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class NeomSliderConstants {

  static final CircularSliderAppearance appearance01 = CircularSliderAppearance(
      customWidths: customWidth01,
      customColors: customColors01,
      startAngle: 180,
      angleRange: 360,
      size: 350.0,
      animationEnabled: false);

  static final customWidth01 = CustomSliderWidths(trackWidth: 3, progressBarWidth: 15, shadowWidth: 20);

  static final customColors01 = CustomSliderColors(
    dotColor: Colors.white.withOpacity(0.8),
    trackColor: Color(0xffFFD4BE).withOpacity(0.4),
    progressBarColor: Color(0xffF6A881),
    shadowColor: Color(0xffFFD4BE),
    shadowStep: 10.0,
    shadowMaxOpacity: 0.6);


  static final CircularSliderAppearance appearance02 = CircularSliderAppearance(
      customWidths: customWidth02,
      customColors: customColors02,
      startAngle: 360,
      angleRange: 180,
      size: 290.0,
      animationEnabled: false);

  static final customWidth02 = CustomSliderWidths(trackWidth: 2, progressBarWidth: 10, shadowWidth: 20);

  static final customColors02 = CustomSliderColors(
    dotColor: Colors.white.withOpacity(0.8),
    trackColor: Color(0xff98DBFC).withOpacity(0.3),
    progressBarColor: Color(0xff6DCFFF),
    shadowColor: Color(0xff98DBFC),
    shadowStep: 15.0,
    shadowMaxOpacity: 0.3);


  static final CircularSliderAppearance appearance03 = CircularSliderAppearance(
      customWidths: customWidth03,
      customColors: customColors03,
      startAngle: 90,
      angleRange: 270,
      size: 210.0,
      animationEnabled: false);

  static final customWidth03 = CustomSliderWidths(trackWidth: 2, progressBarWidth: 10, shadowWidth: 10);

  static final customColors03 = CustomSliderColors(
    dotColor: Colors.white.withOpacity(0.8),
    trackColor: Color(0xffEFC8FC).withOpacity(0.3),
    progressBarColor: Color(0xffA177B0),
    shadowColor: Color(0xffEFC8FC),
    shadowStep: 20.0,
    shadowMaxOpacity: 0.3);

static final CircularSliderAppearance appearance04 = CircularSliderAppearance(
    customWidths: customWidth04,
    customColors: customColors04,
    startAngle: 270,
    angleRange: 270,
    size: 150.0,
    animationEnabled: false);

  static final customWidth04 = CustomSliderWidths(trackWidth: 1, progressBarWidth: 5, shadowWidth: 5);

  static final customColors04 = CustomSliderColors(
      dotColor: Colors.white.withOpacity(0.8),
      trackColor: Color(0xffEFC8FC).withOpacity(0.3),
      progressBarColor: Color(0xffA177B0),
      shadowColor: Color(0xffEFC8FC),
      shadowStep: 20.0,
      shadowMaxOpacity: 0.3);
}