// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
//
// // void main() {
// //   SystemChrome.setEnabledSystemUIOverlays([]);
// //   runApp(MyApp());
// //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
// //     systemNavigationBarColor: Colors.transparent, // navigation bar color
// //     statusBarColor: Colors.transparent,
// //     systemNavigationBarIconBrightness: Brightness.dark, //status bar        color
// //   ));
// // }
// class NeomChromePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//           color: Colors.blue,
//           child: Column(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//               Row(),
//           Text(
//           'Flutter VR',
//           style: TextStyle(
//           fontSize: 60,
//           color: Colors.white,
//           fontWeight: FontWeight.bold
//           ),
//         ),
//         SizedBox(height: 20),
//         RaisedButton(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30)),
//           color: Colors.blue[800],
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Text(
//             'ENTER',
//             style: TextStyle(
//             fontSize: 25,
//             color: Colors.white,
//             ),
//           ),
//         ),
//         onPressed: () => _launchURL(context),
//       ),
//       ],
//     ),
//     ),
//
//     );
//   }
//
// }