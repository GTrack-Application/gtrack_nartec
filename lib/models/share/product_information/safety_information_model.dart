class SafetyInfromationModel {
  int? iD;
  String? safetyDetailedInformation;
  String? linkType;
  String? lang;
  String? targetURL;
  String? gTIN;
  String? logo;
  String? companyName;
  String? process;

  SafetyInfromationModel(
      {this.iD,
      this.safetyDetailedInformation,
      this.linkType,
      this.lang,
      this.targetURL,
      this.gTIN,
      this.logo,
      this.companyName,
      this.process});

  SafetyInfromationModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    safetyDetailedInformation = json['SafetyDetailedInformation'];
    linkType = json['LinkType'];
    lang = json['Lang'];
    targetURL = json['TargetURL'];
    gTIN = json['GTIN'];
    logo = json['logo'];
    companyName = json['companyName'];
    process = json['process'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['SafetyDetailedInformation'] = safetyDetailedInformation;
    data['LinkType'] = linkType;
    data['Lang'] = lang;
    data['TargetURL'] = targetURL;
    data['GTIN'] = gTIN;
    data['logo'] = logo;
    data['companyName'] = companyName;
    data['process'] = process;
    return data;
  }
}
