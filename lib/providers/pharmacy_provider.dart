import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../models/distributor.dart';
import '../models/purchase_record.dart';
import '../models/sale_record.dart';
import '../data/pharmacy_repository.dart';
import '../core/utils/pharmacy_utils.dart';

class PharmacyProvider extends ChangeNotifier {
  final PharmacyRepository _repository = PharmacyRepository();

  // Data lists
  List<Medicine> get medicines => _repository.medicines;
  List<Distributor> get distributors => _repository.distributors;
  List<PurchaseRecord> get purchases => _repository.purchases;
  List<SaleRecord> get sales => _repository.sales;

  // Search queries
  String _inventorySearch = "";
  String get inventorySearch => _inventorySearch;

  String _distributorSearch = "";
  String get distributorSearch => _distributorSearch;

  String _purchaseSearch = "";
  String get purchaseSearch => _purchaseSearch;

  String _salesSearch = "";
  String get salesSearch => _salesSearch;

  // Auth state
  String _userEmail = "pharmacist@smartcare.com";
  String get userEmail => _userEmail;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void setInventorySearch(String query) {
    _inventorySearch = query;
    notifyListeners();
  }

  void setDistributorSearch(String query) {
    _distributorSearch = query;
    notifyListeners();
  }

  void setPurchaseSearch(String query) {
    _purchaseSearch = query;
    notifyListeners();
  }

  void setSalesSearch(String query) {
    _salesSearch = query;
    notifyListeners();
  }

  void login(String email) {
    _userEmail = email;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  // Repository Operations
  void addMedicine(Medicine medicine) {
    _repository.addMedicine(medicine);
    notifyListeners();
  }

  void updateMedicine(Medicine medicine) {
    _repository.updateMedicine(medicine);
    notifyListeners();
  }

  void deleteMedicine(String id) {
    _repository.deleteMedicine(id);
    notifyListeners();
  }

  void addDistributor(Distributor distributor) {
    _repository.addDistributor(distributor);
    notifyListeners();
  }

  void addPurchase(PurchaseRecord purchase) {
    _repository.addPurchase(purchase);
    notifyListeners();
  }

  void addSale(SaleRecord sale) {
    _repository.addSale(sale);
    notifyListeners();
  }

  // Calculated properties based on logic
  List<Medicine> get expiredMedicines => PharmacyUtils.getExpiredMedicines(medicines);
  List<Medicine> get expiringSoonMedicines => PharmacyUtils.getExpiringIn30DaysMedicines(medicines);
  List<Medicine> get lowStockMedicines => PharmacyUtils.getLowStockMedicines(medicines);

  double get todaySalesAmount => _repository.getTodaySalesAmount();
  double get todayPurchaseAmount => _repository.getTodayPurchaseAmount();
}
