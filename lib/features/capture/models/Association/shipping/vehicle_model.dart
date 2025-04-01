class VehicleModel {
  final String id;
  final String plateNumber;
  final String make;
  final String model;
  final int year;
  final String color;
  final String owner;
  final String vinNumber;
  final String glnIdNumber;
  final String giaiNumber;
  final String memberId;
  final String assignedDriverId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final AssignedDriver? assignedDriver;
  final Member? member;

  VehicleModel({
    required this.id,
    required this.plateNumber,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.owner,
    required this.vinNumber,
    required this.glnIdNumber,
    required this.giaiNumber,
    required this.memberId,
    required this.assignedDriverId,
    required this.createdAt,
    required this.updatedAt,
    this.assignedDriver,
    this.member,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] ?? '',
      plateNumber: json['plate_number'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      color: json['color'] ?? '',
      owner: json['owner'] ?? '',
      vinNumber: json['vin_number'] ?? '',
      glnIdNumber: json['gln_id_number'] ?? '',
      giaiNumber: json['giai_number'] ?? '',
      memberId: json['member_id'] ?? '',
      assignedDriverId: json['assignedDriverId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      assignedDriver: json['assignedDriver'] != null
          ? AssignedDriver.fromJson(json['assignedDriver'])
          : null,
      member: json['member'] != null ? Member.fromJson(json['member']) : null,
    );
  }

  @override
  String toString() {
    return '$plateNumber - $make $model ($year)';
  }
}

class AssignedDriver {
  final String id;
  final String memberId;
  final String userName;
  final String email;
  final String password;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssignedDriver({
    required this.id,
    required this.memberId,
    required this.userName,
    required this.email,
    required this.password,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssignedDriver.fromJson(Map<String, dynamic> json) {
    return AssignedDriver(
      id: json['id'] ?? '',
      memberId: json['member_id'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}

class Member {
  final String id;
  final String email;
  final String companyNameEnglish;
  final String companyNameArabic;
  final String contactPerson;
  final String gln;
  final String address;
  final String status;

  Member({
    required this.id,
    required this.email,
    required this.companyNameEnglish,
    required this.companyNameArabic,
    required this.contactPerson,
    required this.gln,
    required this.address,
    required this.status,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      companyNameEnglish: json['companyNameEnglish'] ?? '',
      companyNameArabic: json['companyNameArabic'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      gln: json['gln'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
