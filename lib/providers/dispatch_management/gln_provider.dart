import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/domain/services/models/dispatch_management/gln_model.dart';

class GlnProvider with ChangeNotifier {
  final List<GlnModel> _glnList = [];

  // get glnList
  List<GlnModel> get glnList => [..._glnList];

  // set glnList
  void setGlnList(List<GlnModel> glnList) {
    _glnList.clear();
    _glnList.addAll(glnList);
    notifyListeners();
  }
}
