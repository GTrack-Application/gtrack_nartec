// ignore_for_file: file_names

class SupplierLoginModel {
  String? message;
  String? token;
  Data? data;

  SupplierLoginModel({this.message, this.token, this.data});

  SupplierLoginModel.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  String? userName;
  String? userEmail;
  String? userRole;
  bool? isActive;

  Data(
      {this.userId,
      this.userName,
      this.userEmail,
      this.userRole,
      this.isActive});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userRole = json['user_role'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['user_role'] = userRole;
    data['is_active'] = isActive;
    return data;
  }
}
