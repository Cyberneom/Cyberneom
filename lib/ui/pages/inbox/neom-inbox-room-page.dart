import 'package:cyberneom/ui/pages/inbox/neom-inbox-room-controller-.dart';
import 'package:cyberneom/ui/pages/inbox/widgets/message-tile.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NeomInboxRoomPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeomInboxRoomController>(
      id: NeomPageIdConstants.neomInboxRoom,
      init: NeomInboxRoomController(),
      builder: (_) => Scaffold(
      body: Container(
        decoration: NeomAppTheme.neomBoxDecoration,
        child: _.isLoading ? Center(child: CircularProgressIndicator())
            : Stack(
          children: [Column(children: [Expanded(child: ListView.builder(
              itemCount: _.neomMessages.length,
              itemBuilder: (context, index){
                return MessageTile(
                  message: _.neomMessages.elementAt(index).text,
                  sendByMe: _.neomProfile.name == _.neomMessages.elementAt(index).sender,
                  neommateImgUrl: _.neomInbox.neommates!.first.photoUrl,
                );
              }),),
            Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white70.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                        Radius.circular(30)
                    )
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                          padding:EdgeInsets.only(left: 15),
                          child: TextField(
                          controller: _.textController,
                          onChanged: (text) {
                            _.setMessageText(text);
                          },
                          style: simpleTextStyle(),
                          decoration: InputDecoration(
                              hintText: NeomTranslationConstants.writeYourMessage.tr,
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              border: InputBorder.none
                          ),
                        )),
                    ),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        _.addMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.send),),
                    ),
                  ],
                ),
              ),]
            ),
            Positioned(
              top: 26.0,
              left: 4.0,
              child: BackButton(color: Colors.white),
            )
          ],
        ),
      ),
    ),
    );
  }

  TextStyle simpleTextStyle() {
    return TextStyle(color: Colors.white, fontSize: 16);
  }

  TextStyle biggerTextStyle() {
    return TextStyle(color: Colors.white, fontSize: 17);
  }
}