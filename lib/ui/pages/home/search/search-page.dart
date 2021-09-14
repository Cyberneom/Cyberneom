import 'package:cached_network_image/cached_network_image.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/ui/pages/neommates/neommate-controller.dart';
import 'package:cyberneom/ui/widgets/neom-appbar-search.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeommateController>(
      id: NeomPageIdConstants.search,
      init: NeommateController(),
      builder: (_) => Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: NeomAppBarSearch()),
      body: Container(
        decoration: NeomAppTheme.neomBoxDecoration,
        child: _.isLoading ?
        Center(child: CircularProgressIndicator()) : _.neommates.isEmpty ? Container()
            : ListView.builder(

        itemCount: _.neommates.length,
        itemBuilder: (context, index) {
          NeomProfile neommate = _.neommates.values.elementAt(index);
          return GestureDetector(
              child: ListTile(
                onTap: () => _.getNeommateDetails(neommate),
                leading: Hero(
                tag: neommate.photoUrl,
                child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(neommate.photoUrl),
              ),
            ),
          title: Text(neommate.name),
          subtitle: Row(
              children: [
                Text(NeomUtilities.getTotalNeomChamberPresets(neommate.neomChambers ?? Map()).toString()),
                Icon(Icons.graphic_eq, color: Colors.blueGrey, size: 20,),
                Text(neommate.rootFrequency.tr),
              ]
            ),
          ),
          onLongPress: () => {},
          );
        },
        ),
      )
    ),
    );
  }
}