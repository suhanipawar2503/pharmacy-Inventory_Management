import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../providers/pharmacy_provider.dart';
import '../widgets/common/section_header.dart';
import '../widgets/dashboard/dashboard_card.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PharmacyProvider>();
    
    final totalSales = provider.sales.fold(0.0, (sum, s) => sum + s.grandTotal);
    final totalPurchases = provider.purchases.fold(0.0, (sum, p) => sum + p.totalAmount);
    final totalProducts = provider.medicines.length;
    final expiredCount = provider.expiredMedicines.length;

    // Monthly Chart Data (Jan - Jul 2026) matches Kotlin reference
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"];
    final salesData = [125000.0, 142000.0, 138000.0, 165000.0, 180000.0, 172000.0, 195000.0];
    final purchaseData = [85000.0, 92000.0, 105000.0, 98000.0, 110000.0, 115000.0, 120000.0];

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Banner
              _buildTopBanner(),
              const SizedBox(height: 16),

              const SectionHeader(title: "Financial Summary"),
              const SizedBox(height: 8),

              // Metric Cards Grid
              Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: "Total Sales",
                      value: "₹${(totalSales / 1000).toInt()}k",
                      icon: Icons.point_of_sale_outlined,
                      iconBgColor: AppColors.successGreenLight,
                      iconColor: AppColors.successGreen,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DashboardCard(
                      title: "Total Purchases",
                      value: "₹${(totalPurchases / 1000).toInt()}k",
                      icon: Icons.shopping_bag_outlined,
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
                      title: "Active Products",
                      value: "$totalProducts",
                      icon: Icons.inventory_2_outlined,
                      iconBgColor: AppColors.primaryBlueLight,
                      iconColor: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DashboardCard(
                      title: "Expired Count",
                      value: "$expiredCount",
                      icon: Icons.warning_amber_outlined,
                      iconBgColor: AppColors.alertRedLight,
                      iconColor: AppColors.alertRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const SectionHeader(title: "Monthly Sales vs Purchases (2026)"),
              const SizedBox(height: 8),

              // Interactive Bar Chart Card
              _buildChartCard(months, salesData, purchaseData),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBanner() {
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
                children: const [
                  Text(
                    "Pharmacy Analytics & Reports",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Financial performance & inventory metrics",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assessment,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(List<String> months, List<double> salesData, List<double> purchaseData) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.surfaceBorder),
      ),
      color: AppColors.surfaceWhite,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildLegendItem("Sales", AppColors.successGreen),
                const SizedBox(width: 12),
                _buildLegendItem("Purchases", AppColors.secondaryTeal),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              width: double.infinity,
              child: CustomPaint(
                painter: BarChartPainter(
                  salesData: salesData,
                  purchaseData: purchaseData,
                  months: months,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: months.map((month) => Text(
                month,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<double> salesData;
  final List<double> purchaseData;
  final List<String> months;

  BarChartPainter({
    required this.salesData,
    required this.purchaseData,
    required this.months,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = 220000.0;
    final groupWidth = size.width / months.length;
    final barWidth = groupWidth * 0.35;
    final spacing = 6.0;

    final paintSales = Paint()..color = AppColors.successGreen;
    final paintPurchases = Paint()..color = AppColors.secondaryTeal;

    for (int i = 0; i < months.length; i++) {
      final groupX = i * groupWidth + (groupWidth - (barWidth * 2 + spacing)) / 2;

      // Sales Bar
      final salesBarHeight = (salesData[i] / maxVal) * (size.height - 30);
      canvas.drawRect(
        Rect.fromLTWH(
          groupX,
          size.height - salesBarHeight - 20,
          barWidth,
          salesBarHeight,
        ),
        paintSales,
      );

      // Purchases Bar
      final purchaseBarHeight = (purchaseData[i] / maxVal) * (size.height - 30);
      canvas.drawRect(
        Rect.fromLTWH(
          groupX + barWidth + spacing,
          size.height - purchaseBarHeight - 20,
          barWidth,
          purchaseBarHeight,
        ),
        paintPurchases,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
