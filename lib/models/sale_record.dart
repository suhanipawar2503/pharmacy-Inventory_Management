import 'sale_item.dart';

class SaleRecord {
  final String id;
  final String invoiceNumber;
  final String saleDate; // YYYY-MM-DD
  final List<SaleItem> items;
  final double grandTotal;
  final String customerName;
  final String paymentMode;

  SaleRecord({
    required this.id,
    required this.invoiceNumber,
    required this.saleDate,
    required this.items,
    required this.grandTotal,
    this.customerName = "Walk-in Customer",
    this.paymentMode = "UPI",
  });

  SaleRecord copyWith({
    String? id,
    String? invoiceNumber,
    String? saleDate,
    List<SaleItem>? items,
    double? grandTotal,
    String? customerName,
    String? paymentMode,
  }) {
    return SaleRecord(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      saleDate: saleDate ?? this.saleDate,
      items: items ?? this.items,
      grandTotal: grandTotal ?? this.grandTotal,
      customerName: customerName ?? this.customerName,
      paymentMode: paymentMode ?? this.paymentMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'saleDate': saleDate,
      'items': items.map((x) => x.toJson()).toList(),
      'grandTotal': grandTotal,
      'customerName': customerName,
      'paymentMode': paymentMode,
    };
  }

  factory SaleRecord.fromJson(Map<String, dynamic> json) {
    return SaleRecord(
      id: json['id'],
      invoiceNumber: json['invoiceNumber'],
      saleDate: json['saleDate'],
      items: List<SaleItem>.from(json['items']?.map((x) => SaleItem.fromJson(x))),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      customerName: json['customerName'] ?? "Walk-in Customer",
      paymentMode: json['paymentMode'] ?? "UPI",
    );
  }
}
