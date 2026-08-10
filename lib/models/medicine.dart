class Medicine {
  final String id;
  final String name;
  final String company;
  final String category;
  final String batchNumber;
  final double purchasePrice;
  final double sellingPrice;
  final int quantity;
  final int minStockThreshold;
  final String expiryDate; // YYYY-MM-DD
  final String distributorName;

  Medicine({
    required this.id,
    required this.name,
    required this.company,
    required this.category,
    required this.batchNumber,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.quantity,
    this.minStockThreshold = 20,
    required this.expiryDate,
    required this.distributorName,
  });

  Medicine copyWith({
    String? id,
    String? name,
    String? company,
    String? category,
    String? batchNumber,
    double? purchasePrice,
    double? sellingPrice,
    int? quantity,
    int? minStockThreshold,
    String? expiryDate,
    String? distributorName,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      company: company ?? this.company,
      category: category ?? this.category,
      batchNumber: batchNumber ?? this.batchNumber,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      quantity: quantity ?? this.quantity,
      minStockThreshold: minStockThreshold ?? this.minStockThreshold,
      expiryDate: expiryDate ?? this.expiryDate,
      distributorName: distributorName ?? this.distributorName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company': company,
      'category': category,
      'batchNumber': batchNumber,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'quantity': quantity,
      'minStockThreshold': minStockThreshold,
      'expiryDate': expiryDate,
      'distributorName': distributorName,
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      company: json['company'],
      category: json['category'],
      batchNumber: json['batchNumber'],
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      quantity: json['quantity'],
      minStockThreshold: json['minStockThreshold'] ?? 20,
      expiryDate: json['expiryDate'],
      distributorName: json['distributorName'],
    );
  }
}
