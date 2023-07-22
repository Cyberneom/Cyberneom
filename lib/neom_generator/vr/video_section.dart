// import 'package:cyberneom/neom_generator/vr/neom-360-viewer-controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
//
//
// class VideoSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<Neom360ViewerController>(
//       id: AppPageIdConstants.viewer360,
//       init: Neom360ViewerController(),
//     builder: (_) => Scaffold(
//       body: Center(
//         child: SplitView(
//               viewMode: SplitViewMode.Vertical,
//               children: [
//                 // Video360View(
//                 //   onVideo360ViewCreated: _.onVideo360ViewCreated,
//                 //   url: "https://github.com/stephangopaul/video_samples/blob/master/gb.mp4?raw=true",
//                 //   onPlayInfo: (Video360PlayInfo info) {
//                 //     _.durationText = info.duration.toString();
//                 //     _.totalText = info.total.toString();
//                 //   },
//                 // ),
//                 // Video360View(
//                 //   onVideo360ViewCreated: _.onVideo360ViewCreated,
//                 //   url: "https://github.com/stephangopaul/video_samples/blob/master/gb.mp4?raw=true",
//                 //   onPlayInfo: (Video360PlayInfo info) {
//                 //     _.durationText = info.duration.toString();
//                 //     _.totalText = info.total.toString();
//                 //   },
//                 // ),
//               ],
//               onWeightChanged: (w) => print("Horizon: $w"),
//               // controller: SplitViewController(limits: [null, WeightLimit(max: 0.5)]),
//             ),
//         ),
//       ),
//     );
//
//   }
// }