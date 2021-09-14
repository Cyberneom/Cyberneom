//
// import 'package:cyberneom/ui/widgets/neom-appbar-child.dart';
// import 'package:cyberneom/utils/neom-app-theme.dart';
// import 'package:flutter/material.dart';
// import 'package:video_360/video_360.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MaterialApp(home: Neom360ViewerPage()));
// }
//
// class Neom360ViewerPage extends StatefulWidget {
//   @override
//   _Neom360ViewerPageState createState() => _Neom360ViewerPageState();
// }
//
// class _Neom360ViewerPageState extends State<Neom360ViewerPage> {
//
//
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     controller.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: NeomAppBarChild('Video 360 Plugin example app'),
//       body: Stack(
//         children: [
//           Center(
//             child: Container(
//               width: width,
//               height: height,
//               child: Video360View(
//                 onVideo360ViewCreated: _onVideo360ViewCreated,
//                 url: 'https://multiplatform-f.akamaihd.net/i/multi/will/bunny/big_buck_bunny_,640x360_400,640x360_700,640x360_1000,950x540_1500,.f4v.csmil/master.m3u8',
//                 onPlayInfo: (Video360PlayInfo info) {
//                   setState(() {
//                     durationText = info.duration.toString();
//                     totalText = info.total.toString();
//                   });
//                 },
//               ),
//             ),
//           ),
//           Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   MaterialButton(
//                     onPressed: () {
//                       controller.play();
//                     },
//                     color: NeomAppColor.darkViolet,
//                     child: Text('Play'),
//                   ),
//                   MaterialButton(
//                     onPressed: () {
//                       controller.stop();
//                     },
//                     color: NeomAppColor.darkViolet,
//                     child: Text('Stop'),
//                   ),
//                   MaterialButton(
//                     onPressed: () {
//                       controller.reset();
//                     },
//                     color: NeomAppColor.darkViolet,
//                     child: Text('Reset'),
//                   ),
//                   MaterialButton(
//                     onPressed: () {
//                       controller.jumpTo(80000);
//                     },
//                     color: NeomAppColor.darkViolet,
//                     child: Text('1:20'),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   MaterialButton(
//                     onPressed: () {
//                       controller.seekTo(-2000);
//                     },
//                     color: NeomAppColor.darkViolet,
//                     child: Text('<<'),
//                   ),
//                   MaterialButton(
//                     onPressed: () {
//                       controller.seekTo(2000);
//                     },
//                     color: NeomAppColor.darkViolet,
//                     child: Text('>>'),
//                   ),
//                   Flexible(
//                     child: MaterialButton(
//                       onPressed: () {
//                       },
//                       color: NeomAppColor.darkViolet,
//                       child: Text(_.durationText + ' / ' + _.totalText),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//
// }