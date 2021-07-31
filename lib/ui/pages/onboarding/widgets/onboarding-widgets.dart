import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/constants/message-translation-constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

Widget buildActionChip({
  required neomEnum,
  required Function controllerFunction,
  bool isActive = true}){
  return ActionChip(
    backgroundColor: NeomAppColor.bottomNavigationBar,
    shape: StadiumBorder(side: BorderSide(color: Colors.white70).scale(0.2)),
    label: Text(EnumToString.convertToString(neomEnum).tr,
      style: TextStyle(
        fontSize: NeomAppTheme.chipsFontSize,
      ),
    ),
    onPressed:() {
      isActive ? controllerFunction(neomEnum) :
      Get.snackbar(
          MessageTranslationConstants.introProfileSelection.tr,
          MessageTranslationConstants.featureAvailableSoon.tr,
          snackPosition: SnackPosition.BOTTOM
      );
    },
  );
}

Widget buildContainerTextField(String hint, {required TextEditingController controller}) {
  return Container(
    padding: EdgeInsets.only(left: NeomAppTheme.appPadding, right: NeomAppTheme.appPadding),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: hint),
    )
  );
}

Widget buildPhoneField({required TextEditingController controllerPhone,
  required TextEditingController controllerCountryCode}) {
  return Container(
    padding: EdgeInsets.only(left: NeomAppTheme.appPadding, right: NeomAppTheme.appPadding, bottom: 10),
      decoration: BoxDecoration(
        color: NeomAppColor.bottomNavigationBar,
        borderRadius: BorderRadius.circular(40),
      ),
    child: IntlPhoneField(
      decoration: InputDecoration(
        labelText: NeomTranslationConstants.phoneNumber.tr,
        alignLabelWithHint: true,
      ),
      searchText: NeomTranslationConstants.searchByCountryName.tr,
      initialCountryCode: Get.locale!.countryCode,
      onChanged: (phone) {
        controllerPhone.text = phone.number ?? "";
        controllerCountryCode.text = phone.countryCode ?? "";
      },
      onCountryChanged: (phone) {
        controllerCountryCode.text = phone.countryCode ?? "";
      },
    )
  );
}

Widget buildEntryDateField(DateTime dateOfBirth,
    {required BuildContext context, required dateFunction}) {
  return Container(
    width: NeomAppTheme.fullWidth(context),
    padding: EdgeInsets.only(left: NeomAppTheme.appPadding, right: NeomAppTheme.appPadding),
    decoration: BoxDecoration(
      color: NeomAppColor.bottomNavigationBar,
      borderRadius: BorderRadius.circular(40),
    ),
    child: TextButton(
      onPressed: () {
        DatePicker.showDatePicker(context,
          showTitleActions: false,
          minTime: DateTime(NeomConstants.firstYearDOB, 1, 1),
          maxTime: DateTime(NeomConstants.lastYearDOB, 12, 31),
          theme: DatePickerTheme(
            itemHeight: 50,
            backgroundColor: NeomAppColor.darkViolet.withOpacity(0.5),
            itemStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          onChanged: (date) {
            dateFunction(date);
          },
          currentTime: DateTime.now(),
          locale: EnumToString.fromString(LocaleType.values, Get.locale!.languageCode.substring(0,2)),
        );
      },
      child: Text(
        dateOfBirth == DateTime(NeomConstants.lastYearDOB) ? NeomTranslationConstants.enterDOB.tr
            : DateFormat.yMMMMd(Get.locale.toString()).format(dateOfBirth),
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}

