import 'package:flutter/material.dart';

class GlnProvider with ChangeNotifier {
  final List<String> _glnList = [];

  // get glnList
  List<String> get glnList => [..._glnList];

  // set glnList
  void setGlnList(List<String> glnList) {
    _glnList.clear();
    _glnList.addAll(glnList);
    notifyListeners();
  }
}
