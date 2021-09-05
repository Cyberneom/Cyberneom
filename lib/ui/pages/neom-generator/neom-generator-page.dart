import 'package:cyberneom/ui/pages/auth/widgets/signup-widgets.dart';
import 'package:cyberneom/ui/pages/neom-generator/neom-generator-controller.dart';
import 'package:cyberneom/ui/pages/neom-generator/vr/panorama-view.dart';
import 'package:cyberneom/ui/pages/neom-generator/vr/video_section.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-slider-constant.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:surround_sound/surround_sound.dart';
import 'package:get/get.dart';

class NeomGeneratorPage extends StatelessWidget {


  final _soundController = SoundController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeomGeneratorController>(
        id: NeomPageIdConstants.neomGenerator,
        init: NeomGeneratorController(),
    builder: (_) => Scaffold(
      body: Container(
        decoration: NeomAppTheme.neomBoxDecoration,
        child: Stack(children: [ Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SoundWidget(
            soundController: _soundController,
          ),
          SizedBox(height: 25),
          buildLabel(context, NeomTranslationConstants.frequencyGenerator.tr, ""),
          SizedBox(height: 20),
          ValueListenableBuilder<AudioParam>(
            valueListenable: _soundController,
            builder: (context, AudioParam freqValue, __) {
              AudioParam freqValue = _.getAudioParam();
              return Column(
                children: <Widget>[
                  SleekCircularSlider(
                    appearance: NeomSliderConstants.appearance01,
                    min: NeomConstants.frequencyMin,
                    max: NeomConstants.frequencyMax,
                    initialValue: _.neomChamberPreset.neomFrequency!.frequency,
                    onChange: (double val) {
                      _soundController.setFrequency(val);
                    },
                    innerWidget: (double value) {
                      return Align(
                        alignment: Alignment.center,
                        child: SleekCircularSlider(
                          appearance: NeomSliderConstants.appearance02,
                          min: NeomConstants.positionMin,
                          max: NeomConstants.positionMax,
                          initialValue: freqValue.x,
                          onChange: (double val) {
                            _soundController.setPosition(val, freqValue.y, freqValue.z);
                          },
                          innerWidget: (double v) {
                            return Align(
                              alignment: Alignment.center,
                              child: SleekCircularSlider(
                                appearance: NeomSliderConstants.appearance03,
                                min: NeomConstants.positionMin,
                                max: NeomConstants.positionMax,
                                initialValue: freqValue.y,
                                onChange: (double val) {
                                  _soundController.setPosition(freqValue.x, val, freqValue.z);
                                },
                                innerWidget: (double v) {
                                  return Align(
                                    alignment: Alignment.center,
                                    child: SleekCircularSlider(
                                      appearance: NeomSliderConstants.appearance04,
                                      min: NeomConstants.positionMin,
                                      max: NeomConstants.positionMax,
                                      initialValue: freqValue.z,
                                      onChange: (double val) {
                                        _soundController.setPosition(freqValue.x, freqValue.y, val);
                                      },
                                      innerWidget: (double val) {
                                        return Container(
                                          padding: EdgeInsets.all(25),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              color: _.isPlaying ? NeomAppColor.deepDarkViolet : Colors.transparent,
                                              shape: BoxShape.circle,
                                            ),
                                            child: InkWell(
                                              child: IconButton(
                                                  onPressed: ()  async {
                                                    if(await _soundController.isPlaying()) {
                                                      await _soundController.stop();
                                                      _.changeControllerStatus(false);
                                                    } else {
                                                      _soundController.setFrequency(freqValue.freq);
                                                     _soundController.play();
                                                     _.changeControllerStatus(true);
                                                    }
                                                  },
                                                  icon: Icon(FontAwesomeIcons.om, size: 60)
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Slider(
                    value: freqValue.volume,
                    min: NeomConstants.volumeMin,
                    max: NeomConstants.volumeMax,
                    onChanged: (val) {
                      _soundController.setVolume(val);
                      _.setVolume(val);
                    },
                  ),
                  Text(
                    NeomTranslationConstants.parameters.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Volume: ${(_soundController.value.volume*100).round()}"),
                      Text("Frequency: ${_soundController.value.freq.round()}"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("x-axis: ${_soundController.value.x.toPrecision(2)}"),
                      Text("y-axis: ${_soundController.value.y.toPrecision(2)}"),
                      Text("z-axis: ${_soundController.value.z.toPrecision(2)}"),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          backgroundColor: NeomAppColor.bondiBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),),
                        child: Text(NeomTranslationConstants.savePreset.tr,
                            style: TextStyle(
                                color: Colors.white,fontSize: 18.0,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        onPressed: () => {
                          Alert(
                            context: context,
                            title: NeomTranslationConstants.chamberPrefs.tr,
                            content: Column(
                              children: <Widget>[
                                Text("")
                              ],
                            ),
                            buttons: [
                              DialogButton(
                                child: Text(NeomTranslationConstants.save.tr,
                                  style: TextStyle(color: Colors.deepPurple, fontSize: 15),
                                ),
                                onPressed: () => {
                                  // TODO
                                  // _.presetController.savePresetInChamber(_.neomChamberPreset),
                                  NeomUtilities.showAlert(context, NeomTranslationConstants.aboutCyberneom.tr, NeomTranslationConstants.underConstruction.tr)
                                },
                              ),
                            ],
                          ).show()
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
      Positioned(
        top: 26.0,
        left: 4.0,
        child: BackButton(color: Colors.white),
      ),
        ]),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        FloatingActionButton(
          heroTag: "",
          backgroundColor: Colors.white12,
          mini: true,
          child: Icon(FontAwesomeIcons.vrCardboard, size: 12,color: Colors.white,),
          onPressed: ()=>{
            Get.to(PanoramaView())
          },
        ),
        FloatingActionButton(
          heroTag: " ",
          backgroundColor: Colors.white12,
          mini: true,
          child: Icon(FontAwesomeIcons.globe, size: 12,color: Colors.white,),
          onPressed: ()=> {
            Get.to(VideoSection())
          },
        )
      ],)
    ),
    );
  }
}