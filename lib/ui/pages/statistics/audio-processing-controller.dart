// import 'dart:async';
//
// import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
// import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
// import 'package:cyberneom/utils/neom-utilities.dart';
// import 'package:flutter_fft/flutter_fft.dart';
// import 'package:get/get.dart';
//
//
// class AudioProcessingController extends GetxController  {
//
//   var logger = NeomUtilities.logger;
//   final neomUserController = Get.find<NeomUserController>();
//
//   RxDouble _frequency = 0.0.obs;
//   double get frequency => _frequency.value;
//   set frequency(double frequency) => this._frequency.value = frequency;
//
//   RxString _note = "".obs;
//   String get note => _note.value;
//   set note(String note) => this._note.value = note;
//
//   RxInt _octave = 0.obs;
//   int get octave => _octave.value;
//   set octave(int octave) => this._octave.value = octave;
//
//   RxBool _isRecording = false.obs;
//   bool get isRecording => _isRecording.value;
//   set isRecording(bool isRecording) => this._isRecording.value = isRecording;
//
//   Rx<FlutterFft> _flutterFft = FlutterFft().obs;
//   FlutterFft get flutterFft => _flutterFft.value;
//   set flutterFft(FlutterFft flutterFft) => this._flutterFft.value = flutterFft;
//
//
//
//   RxBool _isPlaying = false.obs;
//   bool get isPlaying => _isPlaying.value;
//   set isPlaying(bool isPlaying) => this._isPlaying.value = isPlaying;
//
//   RxBool _isLoading = true.obs;
//   bool get isLoading => _isLoading.value;
//   set isLoading(bool isLoading) => this._isLoading.value = isLoading;
//
//   @override
//   void onInit() async {
//     super.onInit();
//
//     isRecording = flutterFft.getIsRecording;
//     frequency = flutterFft.getFrequency;
//     note = flutterFft.getNote;
//     octave = flutterFft.getOctave;
//     await _initialize();
//
//   }
//
//   _initialize() async {
//     print("Starting recorder...");
//     // print("Before");
//     // bool hasPermission = await flutterFft.checkPermission();
//     // print("After: " + hasPermission.toString());
//
//     // Keep asking for mic permission until accepted
//     while (!(await flutterFft.checkPermission())) {
//       flutterFft.requestPermission();
//       // IF DENY QUIT PROGRAM
//     }
//
//
//     // await flutterFft.checkPermissions();
//     await flutterFft.startRecorder();
//
//     print("Recorder started...");
//     isRecording = flutterFft.getIsRecording;
//     flutterFft.onRecorderStateChanged.listen(
//             (data) => {
//           print("Changed state, received: $data"),
//
//               frequency = data[1] as double,
//               note = data[2] as String,
//               octave = data[5] as int,
//
//           flutterFft.setNote = note,
//           flutterFft.setFrequency = frequency,
//           flutterFft.setOctave = octave,
//           print("Octave: ${octave.toString()}")
//         },
//         onError: (err) {
//           print("Error: $err");
//         },
//         onDone: () => {print("Isdone")});
//
//     update([NeomPageIdConstants.audioProcessing]);
//   }
//
//   @override
//   FutureOr onClose() {
//     super.onClose();
//   }
//
//
//
//
//
//
// }
//
