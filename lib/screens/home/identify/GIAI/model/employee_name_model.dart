class EmployeeNameModel {
  String? id;
  String? memberId;
  String? userName;
  String? email;
  String? password;
  String? role;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  EmployeeNameModel({
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

  EmployeeNameModel.fromJson(Map<String, dynamic> json) {
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
