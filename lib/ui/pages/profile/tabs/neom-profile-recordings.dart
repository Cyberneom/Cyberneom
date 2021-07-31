import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cyberneom/ui/pages/profile/neom-profile-controller.dart';

class NeomProfileRecordings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GetBuilder<NeomProfileController>(
      id: "neomProfile",
      init: NeomProfileController(),
      builder: (_) => Center(
          child: Text(NeomTranslationConstants.underConstruction.tr,style: textTheme.subtitle2!.copyWith(color: Colors.white),)
        ),
      );
    }
}
