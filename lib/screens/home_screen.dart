import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../providers/pharmacy_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/common/section_header.dart';
import '../widgets/common/sale_card.dart';
import '../widgets/dashboard/dashboard_card.dart';
import '../widgets/dashboard/quick_action_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PharmacyProvider>();

    final totalProducts = provider.medicines.length;
    final totalStock = provider.medicines.fold(0, (sum, item) => sum + item.quantity);
    final lowStockCount = provider.lowStockMedicines.length;
    final expiredCount = provider.expiredMedicines.length;
    final expiringCount = provider.expiringSoonMedicines.length;
    final todaySalesTotal = provider.todaySalesAmount;

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Welcome Pharmacy Banner
            _buildWelcomeBanner(),
            const SizedBox(height: 16),

            // Expiry Alert Banner (if any expired or expiring soon)
            if (expiredCount > 0 || expiringCount > 0) ...[
              _buildExpiryAlert(context, expiredCount, expiringCount),
              const SizedBox(height: 16),
            ],

            // Overview Cards Grid
            const SectionHeader(title: "Dashboard Overview"),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: "Total Products",
                    value: "$totalProducts",
                    icon: Icons.inventory_2_outlined,
                    iconBgColor: AppColors.primaryBlueLight,
                    iconColor: AppColors.primaryBlue,
                    onTap: () {
                      // Handled by tab navigation in MainContainer usually, 
                      // or can be linked to a specific route
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DashboardCard(
                    title: "Total Stock",
                    value: "$totalStock",
                    icon: Icons.category_outlined,
                    iconBgColor: AppColors.secondaryTealLight,
                    iconColor: AppColors.secondaryTeal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: "Today's Sales",
                    value: "₹${todaySalesTotal.toInt()}",
                    icon: Icons.point_of_sale_outlined,
                    iconBgColor: AppColors.successGreenLight,
                    iconColor: AppColors.successGreen,
                    onTap: () {
                      // Handled by tab navigation
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DashboardCard(
                    title: "Low Stock",
                    value: "$lowStockCount",
                    icon: Icons.production_quantity_limits_outlined,
                    iconBgColor: AppColors.alertRedLight,
                    iconColor: AppColors.alertRed,
                    onTap: () {
                      // Handled by tab navigation
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quick Actions Grid
            const SectionHeader(title: "Quick Actions"),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: QuickActionButton(
                    title: "Add Product",
                    icon: Icons.add_circle_outline,
                    color: AppColors.primaryBlue,
                    bgColor: AppColors.primaryBlueLight,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.addProduct),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuickActionButton(
                    title: "New Sale",
                    icon: Icons.receipt_long,
                    color: AppColors.successGreen,
                    bgColor: AppColors.successGreenLight,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.createBill),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: QuickActionButton(
                    title: "Add Purchase",
                    icon: Icons.shopping_bag,
                    color: AppColors.secondaryTeal,
                    bgColor: AppColors.secondaryTealLight,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.addPurchase),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuickActionButton(
                    title: "Scan Bill (OCR)",
                    icon: Icons.qr_code_scanner,
                    color: AppColors.warningOrange,
                    bgColor: AppColors.warningOrangeLight,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.ocrScan),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Recent Sales Activity
            SectionHeader(
              title: "Recent Sales Activity",
              actionText: "View All",
              onActionClick: () {
                // Handled by tab navigation
              },
            ),
            const SizedBox(height: 8),
            ...provider.sales.take(4).map((sale) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: SaleCard(
                sale: sale,
                onTap: () => Navigator.pushNamed(
                  context, 
                  AppRoutes.invoice, 
                  arguments: sale.id
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.primaryBlue,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Smart Care Pharmacy",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "System Operational • All Stocks Synchronized",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_pharmacy,
                color: Colors.white,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiryAlert(BuildContext context, int expiredCount, int expiringCount) {
    final bool isExpired = expiredCount > 0;
    final Color color = isExpired ? AppColors.alertRed : AppColors.warningOrange;
    final Color bgColor = isExpired ? AppColors.alertRedLight : AppColors.warningOrangeLight;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: color, width: 1),
      ),
      color: bgColor,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRoutes.expiry),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Icon(Icons.warning, color: color, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Attention Required",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "$expiredCount Expired • $expiringCount Expiring in 30 Days",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
