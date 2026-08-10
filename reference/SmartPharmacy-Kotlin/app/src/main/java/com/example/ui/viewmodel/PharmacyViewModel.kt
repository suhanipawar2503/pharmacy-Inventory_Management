package com.example.ui.viewmodel

import androidx.lifecycle.ViewModel
import com.example.data.model.Distributor
import com.example.data.model.Medicine
import com.example.data.model.PurchaseRecord
import com.example.data.model.SaleRecord
import com.example.data.repository.PharmacyRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

class PharmacyViewModel(
    private val repository: PharmacyRepository = PharmacyRepository.instance
) : ViewModel() {

    val medicines: StateFlow<List<Medicine>> = repository.medicines
    val distributors: StateFlow<List<Distributor>> = repository.distributors
    val purchases: StateFlow<List<PurchaseRecord>> = repository.purchases
    val sales: StateFlow<List<SaleRecord>> = repository.sales

    // Search queries
    private val _inventorySearch = MutableStateFlow("")
    val inventorySearch: StateFlow<String> = _inventorySearch.asStateFlow()

    private val _distributorSearch = MutableStateFlow("")
    val distributorSearch: StateFlow<String> = _distributorSearch.asStateFlow()

    private val _purchaseSearch = MutableStateFlow("")
    val purchaseSearch: StateFlow<String> = _purchaseSearch.asStateFlow()

    private val _salesSearch = MutableStateFlow("")
    val salesSearch: StateFlow<String> = _salesSearch.asStateFlow()

    // Login & Shop Profile state
    private val _userEmail = MutableStateFlow("pharmacist@smartcare.com")
    val userEmail: StateFlow<String> = _userEmail.asStateFlow()

    private val _isLoggedIn = MutableStateFlow(false)
    val isLoggedIn: StateFlow<Boolean> = _isLoggedIn.asStateFlow()

    fun setInventorySearch(query: String) { _inventorySearch.value = query }
    fun setDistributorSearch(query: String) { _distributorSearch.value = query }
    fun setPurchaseSearch(query: String) { _purchaseSearch.value = query }
    fun setSalesSearch(query: String) { _salesSearch.value = query }

    fun login(email: String) {
        _userEmail.value = email
        _isLoggedIn.value = true
    }

    fun logout() {
        _isLoggedIn.value = false
    }

    fun addMedicine(medicine: Medicine) {
        repository.addMedicine(medicine)
    }

    fun updateMedicine(medicine: Medicine) {
        repository.updateMedicine(medicine)
    }

    fun deleteMedicine(id: String) {
        repository.deleteMedicine(id)
    }

    fun addDistributor(distributor: Distributor) {
        repository.addDistributor(distributor)
    }

    fun addPurchase(purchase: PurchaseRecord) {
        repository.addPurchase(purchase)
    }

    fun addSale(sale: SaleRecord) {
        repository.addSale(sale)
    }

    // Helper utilities for expiry check
    private val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())

    fun isExpired(expiryDateStr: String): Boolean {
        return try {
            val expDate = dateFormat.parse(expiryDateStr) ?: return false
            val today = Date()
            expDate.before(today)
        } catch (e: Exception) {
            false
        }
    }

    fun isExpiringIn30Days(expiryDateStr: String): Boolean {
        return try {
            val expDate = dateFormat.parse(expiryDateStr) ?: return false
            val today = Date()
            if (expDate.before(today)) return false // already expired

            val calendar = Calendar.getInstance()
            calendar.time = today
            calendar.add(Calendar.DAY_OF_YEAR, 30)
            val thirtyDaysFromNow = calendar.time

            expDate.before(thirtyDaysFromNow) || expDate == thirtyDaysFromNow
        } catch (e: Exception) {
            false
        }
    }

    fun getExpiredMedicines(list: List<Medicine>): List<Medicine> {
        return list.filter { isExpired(it.expiryDate) }
    }

    fun getExpiringIn30DaysMedicines(list: List<Medicine>): List<Medicine> {
        return list.filter { isExpiringIn30Days(it.expiryDate) }
    }

    fun getLowStockMedicines(list: List<Medicine>): List<Medicine> {
        return list.filter { it.quantity <= it.minStockThreshold }
    }
}
