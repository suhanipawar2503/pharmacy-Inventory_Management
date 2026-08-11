import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../models/distributor.dart';
import '../providers/pharmacy_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/custom_search_bar.dart';
import '../widgets/common/custom_text_field.dart';
import '../widgets/distributor/distributor_card.dart';

class DistributorListScreen extends StatefulWidget {
  const DistributorListScreen({super.key});

  @override
  State<DistributorListScreen> createState() => _DistributorListScreenState();
}

class _DistributorListScreenState extends State<DistributorListScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<PharmacyProvider>();
    _searchController = TextEditingController(text: provider.distributorSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PharmacyProvider>();
    final distributors = provider.distributors;
    final searchQuery = provider.distributorSearch;

    final filtered = distributors.where((d) {
      return d.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          d.phone.toLowerCase().contains(searchQuery.toLowerCase()) ||
          d.address.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addDistributor),
        backgroundColor: AppColors.secondaryTeal,
        foregroundColor: AppColors.surfaceWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add),
        label: const Text(
          "Add Distributor",
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
                hint: "Search 15+ distributors, phone, city...",
                onChanged: (val) => provider.setDistributorSearch(val),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Registered Distributors (${filtered.length})",
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
                        final dist = filtered[index];
                        return DistributorCard(
                          distributor: dist,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.distributorDetails,
                            arguments: dist.id,
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
          Icon(Icons.warning_amber_rounded, size: 48, color: AppColors.textMuted),
          SizedBox(height: 12),
          Text(
            "No distributors found",
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

class AddDistributorScreen extends StatefulWidget {
  const AddDistributorScreen({super.key});

  @override
  State<AddDistributorScreen> createState() => _AddDistributorScreenState();
}

class _AddDistributorScreenState extends State<AddDistributorScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _gstController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _gstController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveDistributor() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final gst = _gstController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter name and phone number")),
      );
      return;
    }

    final newDist = Distributor(
      id: "D${DateTime.now().millisecondsSinceEpoch.toString().substring(DateTime.now().millisecondsSinceEpoch.toString().length - 4)}",
      name: name,
      phone: phone,
      address: address.isEmpty ? "Commercial Hub" : address,
      gstNumber: gst,
      email: email.isEmpty ? "info@${name.replaceAll(' ', '').toLowerCase()}.com" : email,
    );

    context.read<PharmacyProvider>().addDistributor(newDist);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Distributor Saved Successfully!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        title: const Text(
          "Add Distributor",
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
            CustomTextField(
              controller: _nameController,
              label: "Distributor / Firm Name",
              hint: "e.g. Apex Pharma Wholesale",
              leadingIcon: Icons.local_shipping,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _phoneController,
              label: "Phone Number",
              hint: "+91 98000 12345",
              leadingIcon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _emailController,
              label: "Email Address (Optional)",
              hint: "orders@distributor.com",
              leadingIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _addressController,
              label: "Office / Warehouse Address",
              hint: "Street, Area, City",
              leadingIcon: Icons.location_on,
              singleLine: false,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _gstController,
              label: "GST Number (Optional)",
              hint: "e.g. 27AAAAA0000A1Z5",
              leadingIcon: Icons.receipt,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: "Save Distributor",
              containerColor: AppColors.secondaryTeal,
              onPressed: _saveDistributor,
            ),
          ],
        ),
      ),
    );
  }
}

class DistributorDetailsScreen extends StatelessWidget {
  final String distributorId;

  const DistributorDetailsScreen({
    super.key,
    required this.distributorId,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PharmacyProvider>();
    final distributor = provider.distributors.firstWhere(
      (d) => d.id == distributorId,
      orElse: () => throw Exception("Distributor not found"),
    );

    final suppliedMedicines = provider.medicines.where((med) {
      return med.distributorName.toLowerCase() == distributor.name.toLowerCase();
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        title: const Text(
          "Distributor Profile",
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
            // Distributor Header Card
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
                      distributor.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryTeal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.call_outlined, color: AppColors.secondaryTeal, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          distributor.phone,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, color: AppColors.secondaryTeal, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          distributor.email,
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: AppColors.secondaryTeal, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            distributor.address,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                    if (distributor.gstNumber.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "GSTIN: ${distributor.gstNumber}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondaryTeal,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Quick Call / Mail Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Simulating dialer behavior
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Calling ${distributor.phone}...")),
                      );
                    },
                    icon: const Icon(Icons.call, size: 18),
                    label: const Text("Call Supplier"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryTeal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      fixedSize: const Size.fromHeight(46),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Opening mail client for ${distributor.email}")),
                      );
                    },
                    icon: const Icon(Icons.email, size: 18),
                    label: const Text("Email"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.surfaceBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      fixedSize: const Size.fromHeight(46),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Supplied Medicines Section
            Text(
              "Supplied Medicines (${suppliedMedicines.length})",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            if (suppliedMedicines.isEmpty)
              const Text(
                "No medicines associated with this distributor yet.",
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              )
            else
              Column(
                children: suppliedMedicines.map((med) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                med.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                "Batch: ${med.batchNumber} • ${med.company}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "${med.quantity} in stock",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
