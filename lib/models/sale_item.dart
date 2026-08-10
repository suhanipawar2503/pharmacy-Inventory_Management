class SaleItem {
  final String medicineId;
  final String medicineName;
  final int quantity;
  final double unitPrice;
  final double itemTotal;

  SaleItem({
    required this.medicineId,
    required this.medicineName,
    required this.quantity,
    required this.unitPrice,
    double? itemTotal,
  }) : itemTotal = itemTotal ?? (quantity * unitPrice);

  SaleItem copyWith({
    String? medicineId,
    String? medicineName,
    int? quantity,
    double? unitPrice,
    double? itemTotal,
  }) {
    return SaleItem(
      medicineId: medicineId ?? this.medicineId,
      medicineName: medicineName ?? this.medicineName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      itemTotal: itemTotal ?? this.itemTotal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineId': medicineId,
      'medicineName': medicineName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'itemTotal': itemTotal,
    };
  }

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      medicineId: json['medicineId'],
      medicineName: json['medicineName'],
      quantity: json['quantity'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      itemTotal: (json['itemTotal'] as num).toDouble(),
    );
  }
}
