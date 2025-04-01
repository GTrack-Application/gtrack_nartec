// ignore_for_file: file_names

class CRLoginModel {
  String? crActivity;
  String? crNumber;

  CRLoginModel({this.crActivity, this.crNumber});

  CRLoginModel.fromJson(Map<String, dynamic> json) {
    crActivity = json['cr_activity'];
    crNumber = json['cr_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cr_activity'] = crActivity;
    data['cr_number'] = crNumber;
    return data;
  }
}
