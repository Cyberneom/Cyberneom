
import 'package:cyberneom/ui/pages/neommates/neommate-controller.dart';
import 'package:cyberneom/ui/pages/neommates/neommate-details/widgets/neommate-detail-body.dart';
import 'package:cyberneom/ui/pages/neommates/neommate-details/widgets/neommate-detail-header.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';

class NeommateDetailsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeommateController>(
      id: NeomPageIdConstants.neommate,
      init: NeommateController(),
      builder: (_) => Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: NeomAppTheme.neomBoxDecoration,
          child: _.isLoading ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  NeommateDetailHeader(),
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: NeommateDetailBody(),
                  ),
                ],
              ),
          ),
        ),
      ),
    );
  }
}
