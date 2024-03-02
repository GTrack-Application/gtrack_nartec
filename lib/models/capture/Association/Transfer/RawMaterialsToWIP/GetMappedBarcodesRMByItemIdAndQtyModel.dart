// ignore_for_file: file_names

class GetMappedBarcodesRMByItemIdAndQtyModel {
  int? id;
  String? itemId;
  String? itemName;
  int? availableQuantity;
  String? itemGroupId;

  GetMappedBarcodesRMByItemIdAndQtyModel(
      {this.id,
      this.itemId,
      this.itemName,
      this.availableQuantity,
      this.itemGroupId});

  GetMappedBarcodesRMByItemIdAndQtyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    availableQuantity = json['available_quantity'];
    itemGroupId = json['item_group_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['available_quantity'] = availableQuantity;
    data['item_group_id'] = itemGroupId;
    return data;
  }
}
