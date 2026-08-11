import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../models/purchase_record.dart';
import '../providers/pharmacy_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/custom_search_bar.dart';
import '../widgets/common/custom_text_field.dart';
import '../widgets/common/purchase_card.dart';

class PurchaseListScreen extends StatefulWidget {
  const PurchaseListScreen({super.key});

  @override
  State<PurchaseListScreen> createState() => _PurchaseListScreenState();
}

class _PurchaseListScreenState extends State<PurchaseListScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<PharmacyProvider>();
    _searchController = TextEditingController(text: provider.purchaseSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PharmacyProvider>();
    final purchases = provider.purchases;
    final searchQuery = provider.purchaseSearch;

    final filteredPurchases = purchases.where((p) {
      return p.invoiceNumber.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.distributorName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.medicineName.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        title: const Text(
          "Purchase History",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addPurchase),
        backgroundColor: AppColors.secondaryTeal,
        foregroundColor: AppColors.surfaceWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add),
        label: const Text(
          "Add Purchase",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomSearchBar(
                controller: _searchController,
                hint: "Search invoice, distributor, medicine...",
                onChanged: (val) => provider.setPurchaseSearch(val),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Total Purchases (${filteredPurchases.length})",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filteredPurchases.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                      itemCount: filteredPurchases.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final purchase = filteredPurchases[index];
                        return PurchaseCard(
                          purchase: purchase,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.purchaseDetails,
                            arguments: purchase.id,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.shopping_bag_outlined, size: 48, color: AppColors.textMuted),
          SizedBox(height: 12),
          Text(
            "No purchase records found",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          Text(
            "Try adjusting your search query",
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class AddPurchaseScreen extends StatefulWidget {
  const AddPurchaseScreen({super.key});

  @override
  State<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> {
  final _invoiceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _purchaseDateController = TextEditingController();
  final _expiryDateController = TextEditingController();

  String _selectedDistributor = "";
  String _selectedMedicine = "";

  @override
  void initState() {
    super.initState();
    final provider = context.read<PharmacyProvider>();
    
    if (provider.distributors.isNotEmpty) {
      _selectedDistributor = provider.distributors.first.name;
    } else {
      _selectedDistributor = "MedLife Wholesale";
    }

    if (provider.medicines.isNotEmpty) {
      _selectedMedicine = provider.medicines.first.name;
      _priceController.text = provider.medicines.first.purchasePrice.toString();
    } else {
      _selectedMedicine = "Amoxicillin 500mg";
      _priceController.text = "35.0";
    }

    _invoiceController.text = "INV-PUR-2026-${1000 + (DateTime.now().millisecond % 9000)}";
    _purchaseDateController.text = "2026-07-25";
    _quantityController.text = "50";
    _expiryDateController.text = "2028-06-30";
  }

  @override
  void dispose() {
    _invoiceController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _purchaseDateController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  void _savePurchase() {
    final qty = int.tryParse(_quantityController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final total = qty * price;

    final provider = context.read<PharmacyProvider>();
    final targetMed = provider.medicines.firstWhere(
      (m) => m.name.toLowerCase() == _selectedMedicine.toLowerCase(),
      orElse: () => provider.medicines.first,
    );

    final record = PurchaseRecord(
      id: "P${DateTime.now().millisecondsSinceEpoch.toString().substring(DateTime.now().millisecondsSinceEpoch.toString().length - 4)}",
      invoiceNumber: _invoiceController.text.trim(),
      distributorName: _selectedDistributor,
      purchaseDate: _purchaseDateController.text.trim(),
      medicineId: targetMed.id,
      medicineName: _selectedMedicine,
      quantity: qty,
      purchasePrice: price,
      expiryDate: _expiryDateController.text.trim(),
      totalAmount: total,
    );

    provider.addPurchase(record);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Purchase saved! Medicine stock increased by $qty")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PharmacyProvider>();
    final qty = int.tryParse(_quantityController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final total = qty * price;

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        title: const Text(
          "New Purchase Order",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdownField(
              label: "Distributor / Supplier",
              value: _selectedDistributor,
              icon: Icons.local_shipping,
              items: provider.distributors.map((d) => d.name).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedDistributor = val!;
                });
              },
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _invoiceController,
              label: "Invoice Number",
              leadingIcon: Icons.receipt,
            ),
            const SizedBox(height: 14),
            _buildDropdownField(
              label: "Select Medicine",
              value: _selectedMedicine,
              icon: Icons.medication,
              items: provider.medicines.map((m) => m.name).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedMedicine = val!;
                  final med = provider.medicines.firstWhere((m) => m.name == val);
                  _priceController.text = med.purchasePrice.toString();
                });
              },
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _quantityController,
                    label: "Quantity Purchased",
                    hint: "50",
                    leadingIcon: Icons.format_list_numbered,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    controller: _priceController,
                    label: "Purchase Price (₹)",
                    hint: "35.0",
                    leadingIcon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _purchaseDateController,
                    label: "Purchase Date",
                    leadingIcon: Icons.calendar_today,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    controller: _expiryDateController,
                    label: "Batch Expiry",
                    leadingIcon: Icons.event,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: AppColors.secondaryTealLight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Invoice Amount:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      "₹${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.secondaryTeal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: "Save Purchase & Update Stock",
              containerColor: AppColors.secondaryTeal,
              onPressed: _savePurchase,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    String? effectiveValue = items.contains(value) ? value : (items.isNotEmpty ? items.first : null);

    return DropdownButtonFormField<String>(
      initialValue: effectiveValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryBlue),
        filled: true,
        fillColor: AppColors.surfaceWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.surfaceBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.surfaceBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
      ),
      items: items.map((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(
            val,
            style: const TextStyle(color: AppColors.textPrimary),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
      dropdownColor: AppColors.surfaceWhite,
      isExpanded: true,
    );
  }
}

class PurchaseDetailsScreen extends StatelessWidget {
  final String purchaseId;

  const PurchaseDetailsScreen({
    super.key,
    required this.purchaseId,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PharmacyProvider>();
    final purchase = provider.purchases.firstWhere(
      (p) => p.id == purchaseId,
      orElse: () => throw Exception("Purchase record not found"),
    );

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        title: const Text(
          "Purchase Details",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: AppColors.secondaryTealLight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Invoice: ${purchase.invoiceNumber}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryTeal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Supplier: ${purchase.distributorName}",
                      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 1,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppColors.surfaceBorder),
              ),
              color: AppColors.surfaceWhite,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    _buildDetailItem("Medicine Name", purchase.medicineName),
                    const SizedBox(height: 12),
                    _buildDetailItem("Purchase Date", purchase.purchaseDate),
                    const SizedBox(height: 12),
                    _buildDetailItem("Quantity Received", "${purchase.quantity} units"),
                    const SizedBox(height: 12),
                    _buildDetailItem("Unit Purchase Price", "₹${purchase.purchasePrice}"),
                    const SizedBox(height: 12),
                    _buildDetailItem("Batch Expiry Date", purchase.expiryDate),
                    const Divider(height: 24, color: AppColors.surfaceBorder),
                    _buildDetailItem(
                      "Grand Total Amount",
                      "₹${purchase.totalAmount}",
                      isBold: true,
                      valueColor: AppColors.secondaryTeal,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value, {
    bool isBold = false,
    Color valueColor = AppColors.textPrimary,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
