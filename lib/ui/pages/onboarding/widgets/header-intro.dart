import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-assets.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:flutter/material.dart';

class HeaderIntro extends StatelessWidget{

  final String subtitle;
  final String cyberneom = NeomConstants.cyberneom_title;

  HeaderIntro({this.subtitle = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      Image.asset(
      NeomAssets.logoSloganEnglish,
      height: 200,
      width: 300,
      ),
      subtitle.isEmpty ? Container() : Text(subtitle,
        textAlign: TextAlign.center,
        style: TextStyle(
        color: Colors.white.withOpacity(1.0),
        fontFamily: NeomAppTheme.fontFamily,
        fontSize: 20.0,
        ),
      ),
    ]);
  }
}
