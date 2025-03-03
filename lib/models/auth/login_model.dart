class LoginModel {
  String? message;
  String? token;
  SubUser? subUser;

  LoginModel({
    this.message,
    this.token,
    this.subUser,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    subUser =
        json['subUser'] != null ? SubUser.fromJson(json['subUser']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['token'] = token;
    if (subUser != null) {
      data['subUser'] = subUser!.toJson();
    }
    return data;
  }
}

class SubUser {
  String? id;
  String? memberId;
  String? userName;
  String? email;
  String? password;
  String? role;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  SubUser({
    this.id,
    this.memberId,
    this.userName,
    this.email,
    this.password,
    this.role,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  SubUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    userName = json['userName'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
    isActive = json['is_active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['userName'] = userName;
    data['email'] = email;
    data['password'] = password;
    data['role'] = role;
    data['is_active'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
