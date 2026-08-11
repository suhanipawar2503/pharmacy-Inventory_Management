import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../models/sale_item.dart';
import '../models/sale_record.dart';
import '../providers/pharmacy_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/custom_search_bar.dart';
import '../widgets/common/custom_text_field.dart';
import '../widgets/common/sale_card.dart';

class SalesListScreen extends StatefulWidget {
  const SalesListScreen({super.key});

  @override
  State<SalesListScreen> createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<PharmacyProvider>();
    _searchController = TextEditingController(text: provider.salesSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PharmacyProvider>();
    final sales = provider.sales;
    final searchQuery = provider.salesSearch;

    final filtered = sales.where((s) {
      return s.invoiceNumber.toLowerCase().contains(searchQuery.toLowerCase()) ||
          s.customerName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          s.paymentMode.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createBill),
        backgroundColor: AppColors.successGreen,
        foregroundColor: AppColors.surfaceWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.receipt_long),
        label: const Text(
          "Create Bill",
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
                hint: "Search invoice #, customer name...",
                onChanged: (val) => provider.setSalesSearch(val),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Billing Records (${filtered.length})",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final sale = filtered[index];
                        return SaleCard(
                          sale: sale,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.invoice,
                            arguments: sale.id,
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
          Icon(Icons.point_of_sale_outlined, size: 48, color: AppColors.textMuted),
          SizedBox(height: 12),
          Text(
            "No sales records found",
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

class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen({super.key});

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  final _customerNameController = TextEditingController(text: "Walk-in Customer");
  final _quantityController = TextEditingController(text: "1");
  String _selectedPaymentMode = "UPI";
  String _selectedMedName = "";
  final List<SaleItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    final provider = context.read<PharmacyProvider>();
    if (provider.medicines.isNotEmpty) {
      _selectedMedName = provider.medicines.first.name;
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _addItem() {
    final provider = context.read<PharmacyProvider>();
    final targetMed = provider.medicines.firstWhere(
      (m) => m.name.toLowerCase() == _selectedMedName.toLowerCase(),
    );

    final qty = int.tryParse(_quantityController.text) ?? 1;
    if (qty > targetMed.quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Only ${targetMed.quantity} units available in stock!")),
      );
      return;
    }

    setState(() {
      _cartItems.add(SaleItem(
        medicineId: targetMed.id,
        medicineName: targetMed.name,
        quantity: qty,
        unitPrice: targetMed.sellingPrice,
      ));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${targetMed.name} added to bill")),
    );
  }

  void _generateInvoice() {
    final provider = context.read<PharmacyProvider>();
    final grandTotal = _cartItems.fold(0.0, (sum, item) => sum + item.itemTotal);
    final invoiceNo = "INV-SL-2026-${5000 + (DateTime.now().millisecond % 5000)}";

    final saleRecord = SaleRecord(
      id: "S${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}",
      invoiceNumber: invoiceNo,
      saleDate: "2026-07-25",
      items: List.from(_cartItems),
      grandTotal: grandTotal,
      customerName: _customerNameController.text.trim().isEmpty ? "Walk-in Customer" : _customerNameController.text.trim(),
      paymentMode: _selectedPaymentMode,
    );

    provider.addSale(saleRecord);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invoice Generated! Stock reduced automatically.")),
    );
    Navigator.pushReplacementNamed(context, AppRoutes.invoice, arguments: saleRecord.id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PharmacyProvider>();
    final grandTotal = _cartItems.fold(0.0, (sum, item) => sum + item.itemTotal);

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        title: const Text(
          "Create New Bill",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _customerNameController,
              label: "Customer Name",
              leadingIcon: Icons.person,
            ),
            const SizedBox(height: 16),
            
            // Add Medicine to Cart Box
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppColors.surfaceBorder),
              ),
              color: AppColors.surfaceCard,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add Medicine to Bill",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    _buildDropdownField(
                      label: "Select Medicine",
                      value: _selectedMedName,
                      icon: Icons.medication,
                      items: provider.medicines.map((m) => m.name).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedMedName = val!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _quantityController,
                            label: "Qty",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: _addItem,
                          icon: const Icon(Icons.add),
                          label: const Text("Add Item"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            fixedSize: const Size.fromHeight(52),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              "Bill Items (${_cartItems.length})",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            
            if (_cartItems.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "No items added to bill yet",
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ),
              )
            else
              ..._cartItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.surfaceBorder),
                  ),
                  color: AppColors.surfaceWhite,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.medicineName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                "${item.quantity} x ₹${item.unitPrice}",
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "₹${item.itemTotal}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.successGreen,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.alertRed),
                          onPressed: () {
                            setState(() {
                              _cartItems.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
              
            const SizedBox(height: 16),
            const Text(
              "Payment Method",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: ["UPI", "Cash", "Card"].map((mode) {
                final isSelected = _selectedPaymentMode == mode;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        mode,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedPaymentMode = mode;
                          });
                        }
                      },
                      selectedColor: AppColors.successGreen,
                      backgroundColor: AppColors.surfaceCard,
                      showCheckmark: false,
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              color: AppColors.successGreenLight,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Grand Total Amount:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      "₹${grandTotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: AppColors.successGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: "Generate Invoice & Finalize Sale",
              containerColor: AppColors.successGreen,
              enabled: _cartItems.isNotEmpty,
              onPressed: _generateInvoice,
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

class InvoiceScreen extends StatelessWidget {
  final String saleId;

  const InvoiceScreen({
    super.key,
    required this.saleId,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PharmacyProvider>();
    final sale = provider.sales.firstWhere(
      (s) => s.id == saleId,
      orElse: () => throw Exception("Invoice not found"),
    );

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        title: const Text(
          "Official Tax Invoice",
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
            Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.surfaceBorder),
              ),
              color: AppColors.surfaceWhite,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Smart Care Pharmacy",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            Text(
                              "Licensed Retail Chemist • DL: 20B/112233",
                              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                            Text(
                              "MG Road, Healthcare Complex, City",
                              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.successGreenLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "PAID",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.successGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: AppColors.surfaceBorder),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Invoice No:",
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            Text(
                              sale.invoiceNumber,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Date & Payment Mode:",
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            Text(
                              "${sale.saleDate} • ${sale.paymentMode}",
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Customer: ${sale.customerName}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Divider(height: 24, color: AppColors.surfaceBorder),
                    Row(
                      children: const [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Item / Medicine",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Qty",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Price",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Total",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: AppColors.surfaceBorder),
                    ...sale.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.medicineName,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "${item.quantity}",
                              style: const TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "₹${item.unitPrice}",
                              style: const TextStyle(fontSize: 13),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "₹${item.itemTotal}",
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    )),
                    const Divider(height: 24, color: AppColors.surfaceBorder),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Grand Total Amount",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "₹${sale.grandTotal}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.successGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        "Thank you for choosing Smart Care Pharmacy!",
                        style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Invoice Saved to PDF Device Storage")),
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Save PDF"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      fixedSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Sharing Invoice via WhatsApp / Mail")),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text("Share"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.surfaceBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      fixedSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Sending PDF to Thermal Receipt Printer")),
                      );
                    },
                    icon: const Icon(Icons.print),
                    label: const Text("Print"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.surfaceBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      fixedSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
