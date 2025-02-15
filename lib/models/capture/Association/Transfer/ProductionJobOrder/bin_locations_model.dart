class BinLocationsResponse {
  String? message;
  List<BinLocation>? data;

  BinLocationsResponse({this.message, this.data});

  BinLocationsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <BinLocation>[];
      json['data'].forEach((v) {
        data!.add(BinLocation.fromJson(v));
      });
    }
  }
}

class BinLocation {
  String? binLocation;
  int? quantity;

  BinLocation({this.binLocation, this.quantity});

  BinLocation.fromJson(Map<String, dynamic> json) {
    binLocation = json['BinLocation'];
    quantity = json['Quantity'];
  }
}
