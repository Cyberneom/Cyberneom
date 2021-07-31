import 'package:cyberneom/domain/model/neom-chamber-preset.dart';
import 'package:cyberneom/ui/pages/profile/neom-profile-controller.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';

class NeomProfileChambers extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeomProfileController>(
      id: NeomPageIdConstants.neomProfile,
      init: NeomProfileController(),
      builder: (_) => Container(
        width: double.infinity,
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                  itemCount: _.totalNeomChamberPresets.length,
                  itemBuilder: (context, index) {
                    NeomChamberPreset neomChamberPreset = _.totalNeomChamberPresets.values.elementAt(index);
                    return GestureDetector(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(8.0),
                          title: Text(neomChamberPreset.name.isEmpty ? "" : neomChamberPreset.name),
                          subtitle: Row(children: [Text(neomChamberPreset.creatorId.isEmpty ? ""
                              : neomChamberPreset.creatorId.length > NeomConstants.maxCreatorNameLength
                              ? "${neomChamberPreset.creatorId.substring(0,NeomConstants.maxCreatorNameLength)}..."
                              : neomChamberPreset.creatorId),
                            SizedBox(width:5,),
                            ]
                          ),
                          onTap: () => _.getneomChamberPresetDetails(neomChamberPreset),
                          leading: Hero(
                            tag: NeomAppTheme.getLeadingHeroTag(index),
                            child: neomChamberPreset.imgUrl.isEmpty ? Text(""): FadeInImage.memoryNetwork(
                                width: 50.0,
                                placeholder: kTransparentImage,
                                image: neomChamberPreset.imgUrl,
                                fadeInDuration: Duration(milliseconds: 300)
                            ),
                          ),
                        ),
                    );
                  },
                ),
      ),
    );
  }
}
