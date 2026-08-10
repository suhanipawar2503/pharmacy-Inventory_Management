import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/pharmacy_utils.dart';
import '../providers/pharmacy_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/common/custom_filter_chip.dart';
import '../widgets/common/custom_search_bar.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/medicine/medicine_card.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late TextEditingController _searchController;
  String _selectedCategory = "All";

  final List<String> _categories = [
    "All",
    "Low Stock",
    "Antibiotics",
    "Analgesics",
    "Cardiovascular",
    "Antidiabetic",
    "Gastrointestinal",
    "Vitamins & Supplements",
    "Respiratory",
    "Dermatology"
  ];

  @override
  void initState() {
    super.initState();
    final provider = context.read<PharmacyProvider>();
    _searchController = TextEditingController(text: provider.inventorySearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PharmacyProvider>();
    final searchQuery = provider.inventorySearch;

    final filteredMedicines = provider.medicines.where((med) {
      final matchesQuery = med.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          med.company.toLowerCase().contains(searchQuery.toLowerCase()) ||
          med.category.toLowerCase().contains(searchQuery.toLowerCase());

      bool matchesCategory = true;
      if (_selectedCategory == "Low Stock") {
        matchesCategory = med.quantity <= med.minStockThreshold;
      } else if (_selectedCategory != "All") {
        matchesCategory = med.category.toLowerCase() == _selectedCategory.toLowerCase();
      }

      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addProduct),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.surfaceWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add),
        label: const Text(
          "Add Product",
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
                hint: "Search 50+ medicines, brand...",
                onChanged: (value) => provider.setInventorySearch(value),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: _categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CustomFilterChip(
                      label: category,
                      isSelected: _selectedCategory == category,
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Showing ${filteredMedicines.length} Medicines",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filteredMedicines.isEmpty
                  ? const EmptyState(
                      title: "No medicines found",
                      subtitle: "Try adjusting your search or category filter",
                      icon: Icons.warning_rounded,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                      itemCount: filteredMedicines.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final medicine = filteredMedicines[index];
                        return MedicineCard(
                          medicine: medicine,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.productDetails,
                            arguments: medicine.id,
                          ),
                          isExpired: PharmacyUtils.isExpired(medicine.expiryDate),
                          isExpiringSoon: PharmacyUtils.isExpiringIn30Days(medicine.expiryDate),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
