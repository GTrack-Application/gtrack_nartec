class MapModel {
  String? id;
  String? email;
  String? password;
  String? stackholderType;
  String? gs1CompanyPrefix;
  String? companyNameEnglish;
  String? companyNameArabic;
  String? contactPerson;
  String? companyLandline;
  String? mobileNo;
  String? extensions;
  String? zipCode;
  String? website;
  String? gln;
  String? address;
  String? longitude;
  String? latitude;
  String? status;
  String? createdAt;
  String? updatedAt;

  MapModel({
    this.id,
    this.email,
    this.password,
    this.stackholderType,
    this.gs1CompanyPrefix,
    this.companyNameEnglish,
    this.companyNameArabic,
    this.contactPerson,
    this.companyLandline,
    this.mobileNo,
    this.extensions,
    this.zipCode,
    this.website,
    this.gln,
    this.address,
    this.longitude,
    this.latitude,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  MapModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    stackholderType = json['stackholderType'];
    gs1CompanyPrefix = json['gs1CompanyPrefix'];
    companyNameEnglish = json['companyNameEnglish'];
    companyNameArabic = json['companyNameArabic'];
    contactPerson = json['contactPerson'];
    companyLandline = json['companyLandline'];
    mobileNo = json['mobileNo'];
    extensions = json['extension'];
    zipCode = json['zipCode'];
    website = json['website'];
    gln = json['gln'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['password'] = password;
    data['stackholderType'] = stackholderType;
    data['gs1CompanyPrefix'] = gs1CompanyPrefix;
    data['companyNameEnglish'] = companyNameEnglish;
    data['companyNameArabic'] = companyNameArabic;
    data['contactPerson'] = contactPerson;
    data['companyLandline'] = companyLandline;
    data['mobileNo'] = mobileNo;
    data['extension'] = extensions;
    data['zipCode'] = zipCode;
    data['website'] = website;
    data['gln'] = gln;
    data['address'] = address;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
