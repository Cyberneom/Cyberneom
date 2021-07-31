import 'package:cyberneom/ui/pages/neommates/neommate-controller.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NeommateDetailBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return GetBuilder<NeommateController>(
      id: NeomPageIdConstants.neommate,
      init: NeommateController(),
      builder: (_) =>  _.isLoading ? Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _.neommate.name,
            style: textTheme.headline5!.copyWith(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text("${NeomUtilities.getFrequencies(_.neommate)}",
              style: textTheme.subtitle2!.copyWith(color: Colors.white),
            ),),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: !_.address.isNotEmpty && _.distance > 0.0 ? _buildLocationInfo(_.address, _.distance, textTheme) : Container(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(_.neommate.aboutMe.isEmpty ? NeomTranslationConstants.noProfileDesc.tr : _.neommate.aboutMe,
              style: textTheme.bodyText2!.copyWith(color: Colors.white70, fontSize: 16.0),
            ),
          ),
        ],
      ),);
  }

  Widget _buildLocationInfo(String addressSimple, double distance,  TextTheme textTheme) {
    return Row(
        children: <Widget>[
          Icon(
            Icons.place,
            color: Colors.white,
            size: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(addressSimple.isEmpty ? NeomTranslationConstants.notSpecified.tr : addressSimple,
              style: textTheme.subtitle1!.copyWith(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(distance > 0 ? "" : "${distance.ceil().toString()} KM",
              style: textTheme.subtitle2!.copyWith(color: Colors.white),
            ),
          ),
        ],
      );
  }
}
