import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../models/medicine.dart';
import '../providers/pharmacy_provider.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/custom_text_field.dart';

class AddEditProductScreen extends StatefulWidget {
  final String? medicineIdToEdit;

  const AddEditProductScreen({
    super.key,
    this.medicineIdToEdit,
  });

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _companyController;
  late TextEditingController _batchNumberController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _quantityController;
  late TextEditingController _expiryDateController;
  late TextEditingController _thresholdController;

  String _selectedCategory = "Antibiotics";
  String _selectedDistributor = "";

  final List<String> _categoryList = [
    "Antibiotics",
    "Analgesics",
    "Cardiovascular",
    "Antidiabetic",
    "Gastrointestinal",
    "Vitamins & Supplements",
    "Respiratory",
    "Dermatology",
    "Neurology",
    "Nutritional"
  ];

  Medicine? _existingMedicine;

  @override
  void initState() {
    super.initState();
    final provider = context.read<PharmacyProvider>();
    
    if (widget.medicineIdToEdit != null) {
      _existingMedicine = provider.medicines.firstWhere(
        (m) => m.id == widget.medicineIdToEdit,
        orElse: () => throw Exception("Medicine not found"),
      );
    }

    _nameController = TextEditingController(text: _existingMedicine?.name ?? "");
    _companyController = TextEditingController(text: _existingMedicine?.company ?? "");
    _batchNumberController = TextEditingController(text: _existingMedicine?.batchNumber ?? "BAT-2026-01");
    _purchasePriceController = TextEditingController(text: _existingMedicine?.purchasePrice.toString() ?? "");
    _sellingPriceController = TextEditingController(text: _existingMedicine?.sellingPrice.toString() ?? "");
    _quantityController = TextEditingController(text: _existingMedicine?.quantity.toString() ?? "50");
    _expiryDateController = TextEditingController(text: _existingMedicine?.expiryDate ?? "2027-12-31");
    _thresholdController = TextEditingController(text: _existingMedicine?.minStockThreshold.toString() ?? "20");

    if (_existingMedicine != null) {
      _selectedCategory = _existingMedicine!.category;
      _selectedDistributor = _existingMedicine!.distributorName;
    } else {
      if (provider.distributors.isNotEmpty) {
        _selectedDistributor = provider.distributors.first.name;
      } else {
        _selectedDistributor = "MedLife Wholesale";
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _batchNumberController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _quantityController.dispose();
    _expiryDateController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        _expiryDateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  void _saveProduct() {
    if (_nameController.text.trim().isEmpty || _companyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in product name and company")),
      );
      return;
    }

    final provider = context.read<PharmacyProvider>();
    final purchasePrice = double.tryParse(_purchasePriceController.text) ?? 0.0;
    final sellingPrice = double.tryParse(_sellingPriceController.text) ?? 0.0;
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final threshold = int.tryParse(_thresholdController.text) ?? 20;

    if (_existingMedicine == null) {
      final newMed = Medicine(
        id: "M${DateTime.now().millisecondsSinceEpoch.toString().substring(DateTime.now().millisecondsSinceEpoch.toString().length - 4)}",
        name: _nameController.text.trim(),
        company: _companyController.text.trim(),
        category: _selectedCategory,
        batchNumber: _batchNumberController.text.trim(),
        purchasePrice: purchasePrice,
        sellingPrice: sellingPrice,
        quantity: quantity,
        minStockThreshold: threshold,
        expiryDate: _expiryDateController.text.trim(),
        distributorName: _selectedDistributor,
      );
      provider.addMedicine(newMed);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Medicine Saved Successfully!")),
      );
    } else {
      final updatedMed = _existingMedicine!.copyWith(
        name: _nameController.text.trim(),
        company: _companyController.text.trim(),
        category: _selectedCategory,
        batchNumber: _batchNumberController.text.trim(),
        purchasePrice: purchasePrice,
        sellingPrice: sellingPrice,
        quantity: quantity,
        minStockThreshold: threshold,
        expiryDate: _expiryDateController.text.trim(),
        distributorName: _selectedDistributor,
      );
      provider.updateMedicine(updatedMed);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Medicine Updated Successfully!")),
      );
    }

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
        title: Text(
          _existingMedicine == null ? "Add New Product" : "Edit Product",
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Medicine Image Placeholder Box
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Product Image Selected / Updated")),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlueLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primaryBlue),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add_a_photo,
                        color: AppColors.primaryBlue,
                        size: 32,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Tap to upload product image",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _nameController,
                label: "Medicine Name",
                hint: "e.g. Paracetamol 650mg",
                leadingIcon: Icons.medication,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _companyController,
                label: "Company / Manufacturer",
                hint: "e.g. Cipla Ltd",
                leadingIcon: Icons.business,
              ),
              const SizedBox(height: 14),
              
              // Category Dropdown
              _buildDropdownField(
                label: "Category",
                value: _selectedCategory,
                icon: Icons.category,
                items: _categoryList,
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val!;
                  });
                },
              ),
              const SizedBox(height: 14),
              
              CustomTextField(
                controller: _batchNumberController,
                label: "Batch Number",
                hint: "e.g. BAT-2026-88",
                leadingIcon: Icons.qr_code,
              ),
              const SizedBox(height: 14),
              
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _purchasePriceController,
                      label: "Purchase Price (₹)",
                      hint: "45.0",
                      leadingIcon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: _sellingPriceController,
                      label: "Selling Price (₹)",
                      hint: "75.0",
                      leadingIcon: Icons.sell,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _quantityController,
                      label: "Quantity",
                      hint: "100",
                      leadingIcon: Icons.format_list_numbered,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: _thresholdController,
                      label: "Min Stock Threshold",
                      hint: "20",
                      leadingIcon: Icons.warning_amber_rounded,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              CustomTextField(
                controller: _expiryDateController,
                label: "Expiry Date (YYYY-MM-DD)",
                hint: "2028-05-31",
                leadingIcon: Icons.calendar_today,
                trailingIcon: IconButton(
                  icon: const Icon(Icons.date_range, color: AppColors.primaryBlue),
                  onPressed: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: 14),
              
              // Distributor Selector Dropdown
              _buildDropdownField(
                label: "Primary Distributor",
                value: _selectedDistributor,
                icon: Icons.local_shipping,
                items: provider.distributors.map((d) => d.name).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedDistributor = val!;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: const BorderSide(color: AppColors.surfaceBorder),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      text: _existingMedicine == null ? "Save Product" : "Update Product",
                      onPressed: _saveProduct,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
    // Ensure value is in items to avoid error
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
          child: Text(val, style: const TextStyle(color: AppColors.textPrimary)),
        );
      }).toList(),
      onChanged: onChanged,
      icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
      dropdownColor: AppColors.surfaceWhite,
    );
  }
}
