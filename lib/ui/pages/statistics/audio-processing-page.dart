// import 'package:cyberneom/ui/pages/statistics/audio-processing-controller.dart';
// import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class AudioProcessingPage extends StatelessWidget {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AudioProcessingController>(
//         id: NeomPageIdConstants.audioProcessing,
//         init: AudioProcessingController(),
//         builder: (_) => Scaffold(
//           backgroundColor: Colors.purple,
//           body: Obx(()=>Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _.isRecording
//                     ? Text("Current note: ${_.note},${_.octave.toString()}",
//                     style: TextStyle(fontSize: 30))
//                     : Text("Not Recording", style: TextStyle(fontSize: 35)),
//                 _.isRecording
//                     ? Text(
//                     "Current frequency: ${_.frequency.toStringAsFixed(2)}",
//                     style: TextStyle(fontSize: 30))
//                     : Text("Not Recording", style: TextStyle(fontSize: 35))
//               ],
//             ),
//           ),),
//         )
//     );
//   }
// }