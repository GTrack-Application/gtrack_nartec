// ignore_for_file: file_names

class BrandOwnerLoginModel {
  String? message;
  String? token;
  Data? data;

  BrandOwnerLoginModel({this.message, this.token, this.data});

  BrandOwnerLoginModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['token'] = token;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? userID;
  String? userName;
  String? email;
  String? addedByMemberID;
  bool? isSuperAdmin;

  Data(
      {this.userID,
      this.userName,
      this.email,
      this.addedByMemberID,
      this.isSuperAdmin});

  Data.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    userName = json['UserName'];
    email = json['Email'];
    addedByMemberID = json['AddedByMemberID'];
    isSuperAdmin = json['IsSuperAdmin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['UserName'] = userName;
    data['Email'] = email;
    data['AddedByMemberID'] = addedByMemberID;
    data['IsSuperAdmin'] = isSuperAdmin;
    return data;
  }
}
