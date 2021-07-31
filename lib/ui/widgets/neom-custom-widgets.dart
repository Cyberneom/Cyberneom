import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


Widget customText(String msg,
    { Key? key,
      required TextStyle style,
      required BuildContext context,
      TextAlign textAlign = TextAlign.justify,
      TextOverflow overflow = TextOverflow.visible,
      bool softWrap = true}) {
  if (msg.isEmpty) {
    return SizedBox(
      height: 0,
      width: 0,
    );
  } else {
    var fontSize = style.fontSize ?? Theme.of(context).textTheme.bodyText2!.fontSize;
    style = style.copyWith(
      fontSize: fontSize! - (NeomAppTheme.fullWidth(context) <= 375 ? 2 : 0),
    );
    return Text(
      msg,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      softWrap: softWrap,
      key: key,
    );
  }
}

AppBar header(context, {bool isTimeLine=false, String pageTitle = ""}) {
  return AppBar(
    title:  Text(
      isTimeLine ? "cyberneom" : pageTitle,
      style: TextStyle(
        fontSize: isTimeLine? 50.0:22.0,
        fontFamily: isTimeLine? NeomAppTheme.fontFamily : "",
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
  );
}

