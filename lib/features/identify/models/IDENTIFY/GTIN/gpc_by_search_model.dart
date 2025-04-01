class GPCBySearchModel {
  String? value;
  String? gpcCode;

  GPCBySearchModel({this.value, this.gpcCode});

  GPCBySearchModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    gpcCode = json['gpcCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['gpcCode'] = gpcCode;
    return data;
  }
}
