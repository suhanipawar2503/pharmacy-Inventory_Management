package com.example.data.model

data class Medicine(
    val id: String,
    val name: String,
    val company: String,
    val category: String,
    val batchNumber: String,
    val purchasePrice: Double,
    val sellingPrice: Double,
    val quantity: Int,
    val minStockThreshold: Int = 20,
    val expiryDate: String, // YYYY-MM-DD
    val distributorName: String
)

data class Distributor(
    val id: String,
    val name: String,
    val phone: String,
    val address: String,
    val gstNumber: String,
    val email: String
)

data class PurchaseRecord(
    val id: String,
    val invoiceNumber: String,
    val distributorName: String,
    val purchaseDate: String, // YYYY-MM-DD
    val medicineId: String,
    val medicineName: String,
    val quantity: Int,
    val purchasePrice: Double,
    val expiryDate: String,
    val totalAmount: Double = quantity * purchasePrice
)

data class SaleItem(
    val medicineId: String,
    val medicineName: String,
    val quantity: Int,
    val unitPrice: Double,
    val itemTotal: Double = quantity * unitPrice
)

data class SaleRecord(
    val id: String,
    val invoiceNumber: String,
    val saleDate: String, // YYYY-MM-DD
    val items: List<SaleItem>,
    val grandTotal: Double,
    val customerName: String = "Walk-in Customer",
    val paymentMode: String = "UPI"
)
