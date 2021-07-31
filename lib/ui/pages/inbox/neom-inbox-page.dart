import 'package:cyberneom/domain/model/neom-inbox.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/ui/pages/inbox/neom-inbox-controller.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NeomInboxPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeomInboxController>(
      id: NeomPageIdConstants.neomInbox,
      init: NeomInboxController(),
      builder: (_) =>
          Scaffold(
            extendBodyBehindAppBar: true,
            body: Container(
              decoration: NeomAppTheme.neomBoxDecoration,
              child:  _.isLoading ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                  itemCount: _.neomInboxs.length,
                  itemBuilder: (context, index) {
                    NeomInbox neomInbox = _.neomInboxs.elementAt(index);
                    NeomProfile neommate = neomInbox.neommates!.first;
                    return GestureDetector(
                      child: ListTile(
                        onTap: () =>
                            Get.toNamed(NeomRouteConstants.INBOX_ROOM,
                                arguments: neomInbox),
                        leading: Hero(
                          tag: neommate.photoUrl,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(neommate.photoUrl.isEmpty ? NeomConstants.noImageUrl : neommate.photoUrl),
                          ),
                        ),
                        title: Row(children: [
                          Text(neommate.name),
                        ]),
                        subtitle: Text(neomInbox.lastMessage!.text)
                      ),
                      onLongPress: () => {},
                    );
                  }
              ),
            ),
          ),
    );
  }
}