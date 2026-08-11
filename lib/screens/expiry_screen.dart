import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../providers/pharmacy_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/medicine/medicine_card.dart';

class ExpiryScreen extends StatefulWidget {
  const ExpiryScreen({super.key});

  @override
  State<ExpiryScreen> createState() => _ExpiryScreenState();
}

class _ExpiryScreenState extends State<ExpiryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PharmacyProvider>();
    final expiredList = provider.expiredMedicines;
    final expiringSoonList = provider.expiringSoonMedicines;

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        title: const Text(
          "Expiry Management",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: _tabController.index == 0 ? AppColors.alertRed : AppColors.warningOrange,
                indicatorWeight: 3,
                labelColor: _tabController.index == 0 ? AppColors.alertRed : AppColors.warningOrange,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: "Expired (${expiredList.length})"),
                  Tab(text: "Expiring in 30 Days (${expiringSoonList.length})"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildExpiryList(context, expiredList, true),
                _buildExpiryList(context, expiringSoonList, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiryList(BuildContext context, List<dynamic> list, bool isExpiredTab) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_rounded,
              size: 48,
              color: AppColors.successGreen,
            ),
            const SizedBox(height: 12),
            Text(
              isExpiredTab ? "No Expired Medicines!" : "No Medicines Expiring in 30 Days!",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Text(
              "Your inventory is fresh and safe.",
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final medicine = list[index];
        return Column(
          children: [
            MedicineCard(
              medicine: medicine,
              isExpired: isExpiredTab,
              isExpiringSoon: !isExpiredTab,
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.productDetails,
                arguments: medicine.id,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isExpiredTab)
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Clearance 30% discount tag added to ${medicine.name}")),
                      );
                    },
                    icon: const Icon(Icons.discount, size: 16, color: AppColors.warningOrange),
                    label: const Text(
                      "Apply Clearance Discount",
                      style: TextStyle(fontSize: 12, color: AppColors.warningOrange, fontWeight: FontWeight.bold),
                    ),
                  ),
                TextButton.icon(
                  onPressed: () {
                    context.read<PharmacyProvider>().deleteMedicine(medicine.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${medicine.name} removed from inventory")),
                    );
                  },
                  icon: const Icon(Icons.delete, size: 16, color: AppColors.alertRed),
                  label: const Text(
                    "Dispose / Remove",
                    style: TextStyle(fontSize: 12, color: AppColors.alertRed, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
