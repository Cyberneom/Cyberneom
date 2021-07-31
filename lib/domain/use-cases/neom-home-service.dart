import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class NeomHomeService {
  void changePageView(int index);
  Future<void> verifyLocation();
  modalBottomSheetMenu(BuildContext context);
}

