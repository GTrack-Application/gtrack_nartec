class LoginModel {
  String? message;
  String? token;
  User? user;

  LoginModel({
    this.message,
    this.token,
    this.user,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? email;
  String? stackholderType;
  String? gs1CompanyPrefix;
  String? companyNameEnglish;
  String? companyNameArabic;
  String? contactPerson;
  String? companyLandline;
  String? mobileNo;
  String? zipCode;
  String? website;
  String? gln;
  String? address;
  String? longitude;
  String? latitude;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? gs1Userid;

  User({
    this.id,
    this.email,
    this.stackholderType,
    this.gs1CompanyPrefix,
    this.companyNameEnglish,
    this.companyNameArabic,
    this.contactPerson,
    this.companyLandline,
    this.mobileNo,
    this.zipCode,
    this.website,
    this.gln,
    this.address,
    this.longitude,
    this.latitude,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.gs1Userid,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    stackholderType = json['stackholderType'];
    gs1CompanyPrefix = json['gs1CompanyPrefix'];
    companyNameEnglish = json['companyNameEnglish'];
    companyNameArabic = json['companyNameArabic'];
    contactPerson = json['contactPerson'];
    companyLandline = json['companyLandline'];
    mobileNo = json['mobileNo'];
    zipCode = json['zipCode'];
    website = json['website'];
    gln = json['gln'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    gs1Userid = json['gs1Userid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['stackholderType'] = stackholderType;
    data['gs1CompanyPrefix'] = gs1CompanyPrefix;
    data['companyNameEnglish'] = companyNameEnglish;
    data['companyNameArabic'] = companyNameArabic;
    data['contactPerson'] = contactPerson;
    data['companyLandline'] = companyLandline;
    data['mobileNo'] = mobileNo;
    data['zipCode'] = zipCode;
    data['website'] = website;
    data['gln'] = gln;
    data['address'] = address;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['gs1Userid'] = gs1Userid;
    return data;
  }
}
