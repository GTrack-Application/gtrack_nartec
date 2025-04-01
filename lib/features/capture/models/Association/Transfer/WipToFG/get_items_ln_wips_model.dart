class GetItemsLnWipsModel {
  int? id;
  String? itemId;
  String? itemName;
  int? availableQuantity;
  String? itemGroupId;
  String? locations;

  GetItemsLnWipsModel(
      {this.id,
      this.itemId,
      this.itemName,
      this.availableQuantity,
      this.itemGroupId,
      this.locations});

  GetItemsLnWipsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    availableQuantity = json['available_quantity'];
    itemGroupId = json['item_group_id'];
    locations = json['locations'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['available_quantity'] = availableQuantity;
    data['item_group_id'] = itemGroupId;
    data['locations'] = locations;
    return data;
  }
}
