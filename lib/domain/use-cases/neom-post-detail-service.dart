import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class NeomPostDetailService {

  Future<void> loadInitialInfo();
  buildPostHeader(context);
  handleDeletePost(BuildContext parentContext);

}
