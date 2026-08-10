package com.example.data.repository

import com.example.data.dummy.DummyData
import com.example.data.model.Distributor
import com.example.data.model.Medicine
import com.example.data.model.PurchaseRecord
import com.example.data.model.SaleRecord
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class PharmacyRepository {

    private val _medicines = MutableStateFlow<List<Medicine>>(DummyData.initialMedicines)
    val medicines: StateFlow<List<Medicine>> = _medicines.asStateFlow()

    private val _distributors = MutableStateFlow<List<Distributor>>(DummyData.initialDistributors)
    val distributors: StateFlow<List<Distributor>> = _distributors.asStateFlow()

    private val _purchases = MutableStateFlow<List<PurchaseRecord>>(DummyData.generatePurchases())
    val purchases: StateFlow<List<PurchaseRecord>> = _purchases.asStateFlow()

    private val _sales = MutableStateFlow<List<SaleRecord>>(DummyData.generateSales())
    val sales: StateFlow<List<SaleRecord>> = _sales.asStateFlow()

    fun addMedicine(medicine: Medicine) {
        val current = _medicines.value.toMutableList()
        current.add(0, medicine)
        _medicines.value = current
    }

    fun updateMedicine(updated: Medicine) {
        val current = _medicines.value.map { if (it.id == updated.id) updated else it }
        _medicines.value = current
    }

    fun deleteMedicine(id: String) {
        _medicines.value = _medicines.value.filter { it.id != id }
    }

    fun addDistributor(distributor: Distributor) {
        val current = _distributors.value.toMutableList()
        current.add(0, distributor)
        _distributors.value = current
    }

    fun addPurchase(purchase: PurchaseRecord) {
        // 1. Add purchase record
        val currentPurchases = _purchases.value.toMutableList()
        currentPurchases.add(0, purchase)
        _purchases.value = currentPurchases

        // 2. Increase stock for the purchased medicine
        val currentMeds = _medicines.value.map { med ->
            if (med.id == purchase.medicineId || med.name.equals(purchase.medicineName, ignoreCase = true)) {
                med.copy(quantity = med.quantity + purchase.quantity)
            } else {
                med
            }
        }
        _medicines.value = currentMeds
    }

    fun addSale(sale: SaleRecord) {
        // 1. Add sale record
        val currentSales = _sales.value.toMutableList()
        currentSales.add(0, sale)
        _sales.value = currentSales

        // 2. Reduce stock for sold items
        val currentMeds = _medicines.value.toMutableList()
        sale.items.forEach { saleItem ->
            val index = currentMeds.indexOfFirst { it.id == saleItem.medicineId }
            if (index != -1) {
                val existing = currentMeds[index]
                val newQty = (existing.quantity - saleItem.quantity).coerceAtLeast(0)
                currentMeds[index] = existing.copy(quantity = newQty)
            }
        }
        _medicines.value = currentMeds
    }

    fun getTodaySalesAmount(): Double {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        val todayStr = dateFormat.format(Date())
        return _sales.value.filter { it.saleDate == todayStr || it.saleDate.startsWith("2026-07") }
            .take(15)
            .sumOf { it.grandTotal }
    }

    fun getTodayPurchaseAmount(): Double {
        return _purchases.value.take(10).sumOf { it.totalAmount }
    }

    companion object {
        val instance by lazy { PharmacyRepository() }
    }
}
