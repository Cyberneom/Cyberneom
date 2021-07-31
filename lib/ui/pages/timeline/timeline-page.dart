import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:cyberneom/ui/pages/timeline/timeline-controller.dart';
import 'package:cyberneom/ui/pages/timeline/widgets/timeline-widgets.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';

class TimelinePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimelineController>(
      id: NeomPageIdConstants.timeline,
      init: TimelineController(),
      builder: (_)=> Scaffold(
      body:  Container(
      decoration: NeomAppTheme.neomBoxDecoration,
      child: _.isLoading ? Center(child: CircularProgressIndicator()) :
        RefreshIndicator(
          child: SafeArea(
            child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  topSpace(),
                  buildTimelineList(context, _),
                  topSpace(),
                ],
              ),
            ),
          ),
        ),
        onRefresh: () => _.getTimeline()),
        )
      )
    );
  }

}

