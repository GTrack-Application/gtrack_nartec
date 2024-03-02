class JobOrderDetailsModel {
  int? tblStakeHoldersID;
  String? gLNIDMember;
  int? memberID;
  String? createdDate;
  String? lastUpdateDate;
  String? jobOrderRefNo;
  String? itemSKUCode;
  String? itemRef2D;
  String? itemRefNo;
  String? itemBatchNo;
  String? itemSerialNo;
  String? itemDescription;
  String? jobOrderRefLink;

  JobOrderDetailsModel(
      {this.tblStakeHoldersID,
      this.gLNIDMember,
      this.memberID,
      this.createdDate,
      this.lastUpdateDate,
      this.jobOrderRefNo,
      this.itemSKUCode,
      this.itemRef2D,
      this.itemRefNo,
      this.itemBatchNo,
      this.itemSerialNo,
      this.itemDescription,
      this.jobOrderRefLink});

  JobOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    tblStakeHoldersID = json['tblStakeHoldersID'];
    gLNIDMember = json['GLNID_Member'];
    memberID = json['MemberID'];
    createdDate = json['CreatedDate'];
    lastUpdateDate = json['LastUpdateDate'];
    jobOrderRefNo = json['JobOrderRefNo'];
    itemSKUCode = json['ItemSKUCode'];
    itemRef2D = json['ItemRef2D'];
    itemRefNo = json['ItemRefNo'];
    itemBatchNo = json['ItemBatchNo'];
    itemSerialNo = json['ItemSerialNo'];
    itemDescription = json['ItemDescription'];
    jobOrderRefLink = json['JobOrderRefLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tblStakeHoldersID'] = tblStakeHoldersID;
    data['GLNID_Member'] = gLNIDMember;
    data['MemberID'] = memberID;
    data['CreatedDate'] = createdDate;
    data['LastUpdateDate'] = lastUpdateDate;
    data['JobOrderRefNo'] = jobOrderRefNo;
    data['ItemSKUCode'] = itemSKUCode;
    data['ItemRef2D'] = itemRef2D;
    data['ItemRefNo'] = itemRefNo;
    data['ItemBatchNo'] = itemBatchNo;
    data['ItemSerialNo'] = itemSerialNo;
    data['ItemDescription'] = itemDescription;
    data['JobOrderRefLink'] = jobOrderRefLink;
    return data;
  }
}
