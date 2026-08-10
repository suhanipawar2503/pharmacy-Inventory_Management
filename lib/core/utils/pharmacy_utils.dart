import 'package:intl/intl.dart';
import '../../models/medicine.dart';

class PharmacyUtils {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  static bool isExpired(String expiryDateStr) {
    try {
      final expDate = _dateFormat.parse(expiryDateStr);
      final today = DateTime.now();
      // Reset time components for accurate date comparison
      final todayDate = DateTime(today.year, today.month, today.day);
      return expDate.isBefore(todayDate);
    } catch (e) {
      return false;
    }
  }

  static bool isExpiringIn30Days(String expiryDateStr) {
    try {
      final expDate = _dateFormat.parse(expiryDateStr);
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      
      if (expDate.isBefore(todayDate)) return false; // already expired

      final thirtyDaysFromNow = todayDate.add(const Duration(days: 30));
      return expDate.isBefore(thirtyDaysFromNow) || expDate.isAtSameMomentAs(thirtyDaysFromNow);
    } catch (e) {
      return false;
    }
  }

  static List<Medicine> getExpiredMedicines(List<Medicine> list) {
    return list.where((m) => isExpired(m.expiryDate)).toList();
  }

  static List<Medicine> getExpiringIn30DaysMedicines(List<Medicine> list) {
    return list.where((m) => isExpiringIn30Days(m.expiryDate)).toList();
  }

  static List<Medicine> getLowStockMedicines(List<Medicine> list) {
    return list.where((m) => m.quantity <= m.minStockThreshold).toList();
  }
}
