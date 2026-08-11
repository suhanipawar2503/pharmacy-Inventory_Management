import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../models/purchase_record.dart';
import '../providers/pharmacy_provider.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/custom_text_field.dart';

class OcrBillScanScreen extends StatefulWidget {
  const OcrBillScanScreen({super.key});

  @override
  State<OcrBillScanScreen> createState() => _OcrBillScanScreenState();
}

class _OcrBillScanScreenState extends State<OcrBillScanScreen> {
  bool _isScanSimulated = false;

  final _medicineNameController = TextEditingController(text: "Azithromycin 500mg");
  final _quantityController = TextEditingController(text: "100");
  final _purchasePriceController = TextEditingController(text: "58.0");
  final _expiryDateController = TextEditingController(text: "2028-11-30");
  final _invoiceNumberController = TextEditingController(text: "INV-OCR-9921");
  String _selectedDistributor = "";

  @override
  void initState() {
    super.initState();
    final provider = context.read<PharmacyProvider>();
    if (provider.distributors.isNotEmpty) {
      _selectedDistributor = provider.distributors.first.name;
    } else {
      _selectedDistributor = "MedLife Wholesale Traders";
    }
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    _quantityController.dispose();
    _purchasePriceController.dispose();
    _expiryDateController.dispose();
    _invoiceNumberController.dispose();
    super.dispose();
  }

  void _simulateScan(String source) {
    setState(() {
      _isScanSimulated = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$source • Text Extracted!")),
    );
  }

  void _savePurchase() {
    final qty = int.tryParse(_quantityController.text) ?? 50;
    final price = double.tryParse(_purchasePriceController.text) ?? 50.0;

    final record = PurchaseRecord(
      id: "P${DateTime.now().millisecondsSinceEpoch.toString().substring(DateTime.now().millisecondsSinceEpoch.toString().length - 4)}",
      invoiceNumber: _invoiceNumberController.text.trim(),
      distributorName: _selectedDistributor,
      purchaseDate: "2026-07-25",
      medicineId: "M03", // Simulated medicine ID
      medicineName: _medicineNameController.text.trim(),
      quantity: qty,
      purchasePrice: price,
      expiryDate: _expiryDateController.text.trim(),
      totalAmount: qty * price,
    );

    context.read<PharmacyProvider>().addPurchase(record);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Scanned Bill saved! Stock increased by $qty units.")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PharmacyProvider>();

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        title: const Text(
          "Smart OCR Bill Scanner",
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
            // Camera / Image Scanner Frame
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.primaryBlue, width: 2),
              ),
              color: AppColors.surfaceCard,
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryBlueLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isScanSimulated ? Icons.check_circle : Icons.photo_camera,
                        color: _isScanSimulated ? AppColors.successGreen : AppColors.primaryBlue,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isScanSimulated
                          ? "Invoice Scanned & Text Recognized!"
                          : "Position supplier invoice bill inside frame",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      _isScanSimulated
                          ? "Review recognized text fields below"
                          : "OCR powered document scanner",
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Buttons: Open Camera & Upload Image
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _simulateScan("Simulated Camera Capture"),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Open Camera"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      fixedSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _simulateScan("Invoice Image Uploaded"),
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Upload Invoice"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryBlue,
                      side: const BorderSide(color: AppColors.primaryBlue),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      fixedSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Recognized Text Section Header
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: AppColors.primaryBlueLight,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: const [
                    Icon(Icons.auto_fix_high, color: AppColors.primaryBlue),
                    SizedBox(width: 8),
                    Text(
                      "OCR Recognized Data (Verify & Edit)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.primaryBlueDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Editable Fields
            CustomTextField(
              controller: _medicineNameController,
              label: "Recognized Medicine Name",
              leadingIcon: Icons.medication,
            ),
            const SizedBox(height: 14),
            _buildDropdownField(
              label: "Recognized Supplier / Distributor",
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
              controller: _invoiceNumberController,
              label: "Recognized Invoice #",
              leadingIcon: Icons.receipt,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _quantityController,
                    label: "Quantity",
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    controller: _purchasePriceController,
                    label: "Purchase Price (₹)",
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _expiryDateController,
              label: "Batch Expiry Date",
              leadingIcon: Icons.calendar_today,
            ),
            const SizedBox(height: 24),

            CustomButton(
              text: "Save Purchase to Inventory",
              containerColor: AppColors.successGreen,
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
