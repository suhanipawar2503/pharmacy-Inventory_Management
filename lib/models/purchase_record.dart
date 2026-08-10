class PurchaseRecord {
  final String id;
  final String invoiceNumber;
  final String distributorName;
  final String purchaseDate; // YYYY-MM-DD
  final String medicineId;
  final String medicineName;
  final int quantity;
  final double purchasePrice;
  final String expiryDate;
  final double totalAmount;

  PurchaseRecord({
    required this.id,
    required this.invoiceNumber,
    required this.distributorName,
    required this.purchaseDate,
    required this.medicineId,
    required this.medicineName,
    required this.quantity,
    required this.purchasePrice,
    required this.expiryDate,
    double? totalAmount,
  }) : totalAmount = totalAmount ?? (quantity * purchasePrice);

  PurchaseRecord copyWith({
    String? id,
    String? invoiceNumber,
    String? distributorName,
    String? purchaseDate,
    String? medicineId,
    String? medicineName,
    int? quantity,
    double? purchasePrice,
    String? expiryDate,
    double? totalAmount,
  }) {
    return PurchaseRecord(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      distributorName: distributorName ?? this.distributorName,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      medicineId: medicineId ?? this.medicineId,
      medicineName: medicineName ?? this.medicineName,
      quantity: quantity ?? this.quantity,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      expiryDate: expiryDate ?? this.expiryDate,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'distributorName': distributorName,
      'purchaseDate': purchaseDate,
      'medicineId': medicineId,
      'medicineName': medicineName,
      'quantity': quantity,
      'purchasePrice': purchasePrice,
      'expiryDate': expiryDate,
      'totalAmount': totalAmount,
    };
  }

  factory PurchaseRecord.fromJson(Map<String, dynamic> json) {
    return PurchaseRecord(
      id: json['id'],
      invoiceNumber: json['invoiceNumber'],
      distributorName: json['distributorName'],
      purchaseDate: json['purchaseDate'],
      medicineId: json['medicineId'],
      medicineName: json['medicineName'],
      quantity: json['quantity'],
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      expiryDate: json['expiryDate'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }
}
