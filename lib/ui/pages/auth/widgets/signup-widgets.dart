import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cyberneom/ui/widgets/neom-custom-widgets.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';

Widget buildLabel(BuildContext context, String title, String msg){
  return Container(
      child:Column(
        children: <Widget>[
          customText(title, context: context, style:TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: customText(msg, context: context,
                style:TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white70),textAlign: TextAlign.center),

          )
        ],
      )
  );
}

Widget buildTwoEntryFields(String firstHint, String secondHint, {required TextEditingController firstController,
  required TextEditingController secondController,
  required BuildContext context}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        width: NeomAppTheme.fullWidth(context)/2.5,
        margin: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: NeomAppColor.bottomNavigationBar,
          borderRadius: BorderRadius.circular(40),
        ),
        child: TextField(
          controller: firstController,
          style: TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
          ),
          decoration: InputDecoration(
            hintText: firstHint,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
              borderSide: BorderSide(color: Colors.blue),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
        ),
      ),
      Container(
        width: NeomAppTheme.fullWidth(context)/2.5,
        margin: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: NeomAppColor.bottomNavigationBar,
          borderRadius: BorderRadius.circular(40),
        ),
        child: TextField(
          controller: secondController,
          style: TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
          ),
          decoration: InputDecoration(
            hintText: secondHint,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
              borderSide: BorderSide(color: Colors.blue),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
        ),
      ),
    ]
  );
}

Widget buildEntryField(String hint, {required TextEditingController controller,
  bool isPassword = false, bool isEmail = false}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 15),
    decoration: BoxDecoration(
      color: NeomAppColor.bottomNavigationBar,
      borderRadius: BorderRadius.circular(40),
    ),
    child: TextField(
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      style: TextStyle(
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
      ),
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
          borderSide: BorderSide(color: Colors.blue),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: NeomAppTheme.appPadding),
      ),
    ),
  );
}



