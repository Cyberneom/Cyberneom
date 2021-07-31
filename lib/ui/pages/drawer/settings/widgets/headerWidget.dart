import 'package:cyberneom/ui/pages/drawer/settings/widgets/customUrlText.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final bool secondHeader;
  const HeaderWidget(this.title,{Key? key, this.secondHeader = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      color: NeomAppColor.mystic.withOpacity(0.05),
      alignment: Alignment.centerLeft,
      child: UrlText(
        text: title,
        style: TextStyle(
            fontSize: 20,
            color: NeomAppColor.lightGrey,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
