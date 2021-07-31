import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cyberneom/domain/model/neom-frequency.dart';
import 'package:cyberneom/ui/pages/onboarding/onboarding-controller.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';

class OnBoardingFrequencyList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
        id: NeomPageIdConstants.onBoardingFrequencies,
        init: OnBoardingController(),
        builder: (_) => ListView.separated(
          itemBuilder: (context, index) => Divider(),
          separatorBuilder: (__, index) {
            NeomFrequency neomFrequency = _.frequencyController.frequencies.values.elementAt(index);
            return GestureDetector(
              child: ListTile(
                title: Text(neomFrequency.name.tr),
                subtitle: Text(neomFrequency.description.tr),
                leading: Column(mainAxisAlignment: MainAxisAlignment.center,children: [Text(neomFrequency.frequency.toString()),Text(NeomConstants.HZ),],),
                trailing: IconButton(
                  alignment: Alignment.center,
                  icon:  Icon(
                      Icons.multitrack_audio_sharp, color: neomFrequency.isFav ? Colors.deepPurple:Colors.grey),
                  onPressed: () {
                    if(neomFrequency.isFav){
                      _.removeFrequencyInstrumentIntro(index);
                    } else {
                      _.addFrequency(index);
                    }
                  }
                ),
              ),
              onTap: () {
                if(neomFrequency.isFav){
                  _.removeFrequencyInstrumentIntro(index);
                } else {
                  _.addFrequency(index);
                }
              } ,
            );
          },
        itemCount: _.frequencyController.frequencies.length,
      ),
    );
  }
}