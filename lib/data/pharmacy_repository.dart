import 'package:intl/intl.dart';
import '../models/medicine.dart';
import '../models/distributor.dart';
import '../models/purchase_record.dart';
import '../models/sale_record.dart';
import 'dummy_data.dart';

class PharmacyRepository {
  List<Medicine> _medicines = DummyData.initialMedicines;
  List<Distributor> _distributors = DummyData.initialDistributors;
  List<PurchaseRecord> _purchases = DummyData.generatePurchases();
  List<SaleRecord> _sales = DummyData.generateSales();

  List<Medicine> get medicines => List.unmodifiable(_medicines);
  List<Distributor> get distributors => List.unmodifiable(_distributors);
  List<PurchaseRecord> get purchases => List.unmodifiable(_purchases);
  List<SaleRecord> get sales => List.unmodifiable(_sales);

  void addMedicine(Medicine medicine) {
    _medicines = [medicine, ..._medicines];
  }

  void updateMedicine(Medicine updated) {
    _medicines = _medicines.map((m) => m.id == updated.id ? updated : m).toList();
  }

  void deleteMedicine(String id) {
    _medicines = _medicines.where((m) => m.id != id).toList();
  }

  void addDistributor(Distributor distributor) {
    _distributors = [distributor, ..._distributors];
  }

  void addPurchase(PurchaseRecord purchase) {
    // 1. Add purchase record
    _purchases = [purchase, ..._purchases];

    // 2. Increase stock for the purchased medicine
    _medicines = _medicines.map((med) {
      if (med.id == purchase.medicineId || 
          med.name.toLowerCase() == purchase.medicineName.toLowerCase()) {
        return med.copyWith(quantity: med.quantity + purchase.quantity);
      }
      return med;
    }).toList();
  }

  void addSale(SaleRecord sale) {
    // 1. Add sale record
    _sales = [sale, ..._sales];

    // 2. Reduce stock for sold items
    final updatedMeds = List<Medicine>.from(_medicines);
    for (var saleItem in sale.items) {
      final index = updatedMeds.indexWhere((m) => m.id == saleItem.medicineId);
      if (index != -1) {
        final existing = updatedMeds[index];
        final newQty = (existing.quantity - saleItem.quantity).clamp(0, double.infinity).toInt();
        updatedMeds[index] = existing.copyWith(quantity: newQty);
      }
    }
    _medicines = updatedMeds;
  }

  double getTodaySalesAmount() {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // The Kotlin repo had a specific filter for 2026-07 which seems like a dummy data thing
    return _sales
        .where((s) => s.saleDate == todayStr || s.saleDate.startsWith("2026-07"))
        .take(15)
        .fold(0.0, (sum, s) => sum + s.grandTotal);
  }

  double getTodayPurchaseAmount() {
    return _purchases.take(10).fold(0.0, (sum, p) => sum + p.totalAmount);
  }

  // Singleton pattern as used in Kotlin
  static final PharmacyRepository instance = PharmacyRepository._internal();
  PharmacyRepository._internal();
  factory PharmacyRepository() => instance;
}
