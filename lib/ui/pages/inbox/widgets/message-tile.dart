import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String neommateImgUrl;


  MessageTile({this.message = "", this.sendByMe = false, this.neommateImgUrl = ""});


  @override
  Widget build(BuildContext context) {
    return sendByMe ? Container(
      padding: EdgeInsets.only(
          top: 0,
          bottom: 8,
          left: 0,
          right: 20),
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(left: 30),
        padding: EdgeInsets.only(
            top: 15, bottom: 15, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ),
            gradient: LinearGradient(
              colors: [
                Color(0xff007EF4),
                Color(0xff2A75BC)
              ]
            )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: NeomAppTheme.fontFamily,
                fontWeight: FontWeight.w300)
        ),
      ),
    ) : Stack(children: [
      GestureDetector(child: CircleAvatar(
        backgroundImage: NetworkImage(neommateImgUrl.isEmpty ? NeomConstants.noImageUrl : neommateImgUrl),
        radius: 25.0,
      ),
        onTap: ()=> print(""),
      ),
      Container(
      padding: EdgeInsets.only(
          top: 0,
          bottom: 8,
          left: 55,
          right: 0),
      child: Container(
        margin: EdgeInsets.only(right: 20),
        padding: EdgeInsets.only(
            top: 15, bottom: 15, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
          color: Color(0x1AFFFFFF),
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: NeomAppTheme.fontFamily,
                fontWeight: FontWeight.w300)
        ),
      ),),
    ]);
  }
}