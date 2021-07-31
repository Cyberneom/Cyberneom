import 'package:cyberneom/ui/pages/auth/widgets/signup-widgets.dart';
import 'package:cyberneom/ui/pages/neom-generator/neom-generator-controller.dart';
import 'package:cyberneom/ui/pages/static/splash-page.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-slider-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:surround_sound/surround_sound.dart';
import 'package:get/get.dart';

class NeomGeneratorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeomGeneratorController>(
      id: NeomPageIdConstants.neomGenerator,
      init: NeomGeneratorController(),
      builder: (_) => Scaffold(
      body: _.isLoading ? SplashPage() : Container(
        decoration: NeomAppTheme.neomBoxDecoration,
        child: Stack(children: [ Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SoundWidget(
              soundController: _.soundController,
            ),
            SizedBox(height: 35),
            buildLabel(context, NeomTranslationConstants.frequencyGenerator.tr, ""),
            SizedBox(height: 20),
            ValueListenableBuilder<AudioParam>(
              valueListenable: _.soundController,
              builder: (context, freqValue, __) {
                return Column(
                  children: <Widget>[
                    SleekCircularSlider(
                      appearance: NeomSliderConstants.appearance01,
                      min: NeomConstants.frequencyMin,
                      max: NeomConstants.frequencyMax,
                      initialValue: _.neomChamberPreset.neomFrequency!.frequency,
                      onChange: (double val) {
                        _.neomChamberPreset.neomFrequency!.frequency = val;
                        _.setFrequency(_.neomChamberPreset.neomFrequency!);
                      },
                      innerWidget: (double value) {
                        return Align(
                          alignment: Alignment.center,
                          child: SleekCircularSlider(
                            appearance: NeomSliderConstants.appearance02,
                            min: NeomConstants.positionMin,
                            max: NeomConstants.positionMax,
                            initialValue: _.neomChamberPreset.neomParameter!.x,
                            onChange: (double val) {
                              _.neomChamberPreset.neomParameter!.x = val;
                              _.setPosition(_.neomChamberPreset.neomParameter!);
                            },
                            innerWidget: (double v) {
                              return Align(
                                alignment: Alignment.center,
                                child: SleekCircularSlider(
                                  appearance: NeomSliderConstants.appearance03,
                                  min: NeomConstants.positionMin,
                                  max: NeomConstants.positionMax,
                                  initialValue: _.neomChamberPreset.neomParameter!.y,
                                  onChange: (double val) {
                                    _.neomChamberPreset.neomParameter!.y = val;
                                    _.setPosition(_.neomChamberPreset.neomParameter!);
                                  },
                                  innerWidget: (double v) {
                                    return Align(
                                      alignment: Alignment.center,
                                      child: SleekCircularSlider(
                                        appearance: NeomSliderConstants.appearance04,
                                        min: NeomConstants.positionMin,
                                        max: NeomConstants.positionMax,
                                        initialValue: _.neomChamberPreset.neomParameter!.z,
                                        onChange: (double val) {
                                          _.neomChamberPreset.neomParameter!.z = val;
                                          _.setPosition(_.neomChamberPreset.neomParameter!);
                                        },
                                        innerWidget: (double val) {
                                          return Container(
                                            padding: EdgeInsets.all(25),
                                            child: Ink(
                                              decoration: BoxDecoration(
                                              color: _.isPlaying ? NeomAppColor.darkViolet : Colors.transparent,
                                              shape: BoxShape.circle,
                                              ),
                                              child: InkWell(
                                                child: IconButton(
                                                  onPressed: ()  async {
                                                    await _.stopPlay();
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
                      value: _.neomChamberPreset.neomParameter!.volume,
                      min: NeomConstants.volumeMin,
                      max: NeomConstants.volumeMax,
                      onChanged: (val) {
                        _.neomChamberPreset.neomParameter!.volume = val;
                        _.setVolume(_.neomChamberPreset.neomParameter!);
                      },
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Parameters",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Volume: ${(_.neomChamberPreset.neomParameter!.volume*100).round()}"),
                        Text("Frequency: ${_.neomChamberPreset.neomFrequency!.frequency.round()}"),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("x-axis: ${_.neomChamberPreset.neomParameter!.x.toPrecision(2)}"),
                        Text("y-axis: ${_.neomChamberPreset.neomParameter!.y.toPrecision(2)}"),
                        Text("z-axis: ${_.neomChamberPreset.neomParameter!.z.toPrecision(2)}"),
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
                                    _.presetController.neomChambers.length > 1 ? Obx(()=> DropdownButton<String>(
                                      items: _.presetController.neomChambers.values.map((chamber) =>
                                          DropdownMenuItem<String>(value: chamber.id, child: Text(chamber.name),)
                                      ).toList(),
                                      onChanged: (String? selectedChamber) {
                                        _.presetController.setSelectedChamber(selectedChamber!);
                                      },
                                      value: _.presetController.neomChamberId,
                                      icon: Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.white),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.grey,
                                      ),
                                    ),) : Text("")
                                  ],
                                ),
                                buttons: [
                                  DialogButton(
                                    child: Text(NeomTranslationConstants.save.tr,
                                      style: TextStyle(color: Colors.deepPurple, fontSize: 15),
                                    ),
                                    onPressed: () => {
                                      _.presetController.savePresetInChamber(_.neomChamberPreset),
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
        ),Positioned(
          top: 26.0,
          left: 4.0,
          child: BackButton(color: Colors.white),
        ),])
        ),
      ),
    );
  }
}