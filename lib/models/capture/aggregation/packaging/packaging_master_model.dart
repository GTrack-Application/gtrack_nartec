class PackagingMasterModel {
  final String id;
  final String ssccNo;
  final int totalPallet;
  final String memberId;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? type;
  final List<PackagingDetailModel> packagingDetail;

  PackagingMasterModel({
    required this.id,
    required this.ssccNo,
    required this.totalPallet,
    required this.memberId,
    required this.transactionDate,
    required this.createdAt,
    this.updatedAt,
    this.type,
    required this.packagingDetail,
  });

  factory PackagingMasterModel.fromJson(Map<String, dynamic> json) {
    return PackagingMasterModel(
      id: json['id'],
      ssccNo: json['SSCCNo'],
      totalPallet: json['TotalPallet'],
      memberId: json['MemberId'],
      transactionDate: DateTime.parse(json['TransactionDate']),
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      type: json['type'],
      packagingDetail: (json['PackagingDetail'] as List)
          .map((e) => PackagingDetailModel.fromJson(e))
          .toList(),
    );
  }
}

class PackagingDetailModel {
  final String id;
  final String packagingMasterId;
  final String ssccNo;
  final String palletCode;
  final String po;
  final String? binLocation;
  final DateTime createdAt;
  final DateTime? updatedAt;

  PackagingDetailModel({
    required this.id,
    required this.packagingMasterId,
    required this.ssccNo,
    required this.palletCode,
    required this.po,
    this.binLocation,
    required this.createdAt,
    this.updatedAt,
  });

  factory PackagingDetailModel.fromJson(Map<String, dynamic> json) {
    return PackagingDetailModel(
      id: json['id'],
      packagingMasterId: json['PackagingMasterId'],
      ssccNo: json['SSCCNo'],
      palletCode: json['PalletCode'],
      po: json['PO'],
      binLocation: json['BinLocation'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

class PackagingPaginationModel {
  final int totalRecords;
  final int totalPages;
  final int currentPage;
  final int recordsPerPage;

  PackagingPaginationModel({
    required this.totalRecords,
    required this.totalPages,
    required this.currentPage,
    required this.recordsPerPage,
  });

  factory PackagingPaginationModel.fromJson(Map<String, dynamic> json) {
    return PackagingPaginationModel(
      totalRecords: json['totalRecords'],
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
      recordsPerPage: json['recordsPerPage'],
    );
  }
}
