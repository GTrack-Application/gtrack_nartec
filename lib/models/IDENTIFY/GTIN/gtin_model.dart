// ignore_for_file: non_constant_identifier_names

class GTINModell {
  final String GTIN;
  final String SerialNo;
  final DateTime EXPIRY_DATE;
  final String BATCH;
  final DateTime MANUFACTURING_DATE;
  final dynamic stackholder;

  GTINModell({
    required this.GTIN,
    required this.SerialNo,
    required this.EXPIRY_DATE,
    required this.BATCH,
    required this.MANUFACTURING_DATE,
    this.stackholder,
  });

  factory GTINModell.fromJson(Map<String, dynamic> json) {
    return GTINModell(
      GTIN: json['GTIN'] ?? '',
      SerialNo: json['SerialNo'] ?? '',
      EXPIRY_DATE: DateTime.parse(json['EXPIRY_DATE'] ?? ''),
      BATCH: json['BATCH'] ?? '',
      MANUFACTURING_DATE: DateTime.parse(json['MANUFACTURING_DATE'] ?? ''),
      stackholder: json['stackholder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'GTIN': GTIN,
      'SerialNo': SerialNo,
      'EXPIRY_DATE': EXPIRY_DATE.toIso8601String(),
      'BATCH': BATCH,
      'MANUFACTURING_DATE': MANUFACTURING_DATE.toIso8601String(),
      'stackholder': stackholder,
    };
  }
}
