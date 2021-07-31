import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PreviousVersionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 300,
        child: Center(
          child: Column(
              children: [
                Text("${NeomConstants.prevVersion1.tr} ${NeomConstants.prevVersion2.tr}",
                  style: TextStyle(fontSize: 15), textAlign: TextAlign.justify,),
                Divider(),
                Text("${NeomConstants.prevVersion4.tr}",
                  style: TextStyle(fontSize: 15), textAlign: TextAlign.end,),
              ]),
          ),
      );
  }

}
