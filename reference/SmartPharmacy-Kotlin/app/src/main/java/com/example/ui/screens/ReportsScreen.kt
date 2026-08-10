package com.example.ui.screens

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Assessment
import androidx.compose.material.icons.filled.Download
import androidx.compose.material.icons.outlined.Inventory2
import androidx.compose.material.icons.outlined.PointOfSale
import androidx.compose.material.icons.outlined.ShoppingBag
import androidx.compose.material.icons.outlined.Warning
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.ui.components.DashboardCard
import com.example.ui.components.SectionHeader
import com.example.ui.theme.*
import com.example.ui.viewmodel.PharmacyViewModel

@Composable
fun ReportsScreen(
    viewModel: PharmacyViewModel
) {
    val medicines by viewModel.medicines.collectAsState()
    val sales by viewModel.sales.collectAsState()
    val purchases by viewModel.purchases.collectAsState()

    val totalSales = sales.sumOf { it.grandTotal }
    val totalPurchases = purchases.sumOf { it.totalAmount }
    val totalProducts = medicines.size
    val expiredCount = viewModel.getExpiredMedicines(medicines).size

    // Monthly Chart Data (Jan - Jul 2026)
    val months = listOf("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul")
    val salesData = listOf(125000f, 142000f, 138000f, 165000f, 180000f, 172000f, 195000f)
    val purchaseData = listOf(85000f, 92000f, 105000f, 98000f, 110000f, 115000f, 120000f)

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(SurfaceWhite)
            .padding(16.dp)
            .verticalScroll(rememberScrollState()),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Top Banner
        Card(
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = PrimaryBlue),
            modifier = Modifier.fillMaxWidth()
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(18.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Text(text = "Pharmacy Analytics & Reports", fontSize = 18.sp, fontWeight = FontWeight.Bold, color = Color.White)
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(text = "Financial performance & inventory metrics", fontSize = 12.sp, color = Color.White.copy(alpha = 0.85f))
                }
                Box(
                    modifier = Modifier
                        .size(44.dp)
                        .clip(CircleShape)
                        .background(Color.White.copy(alpha = 0.2f)),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(imageVector = Icons.Default.Assessment, contentDescription = null, tint = Color.White)
                }
            }
        }

        SectionHeader(title = "Financial Summary")

        // Metric Cards Grid
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            DashboardCard(
                title = "Total Sales",
                value = "₹${(totalSales / 1000).toInt()}k",
                icon = Icons.Outlined.PointOfSale,
                iconBgColor = SuccessGreenLight,
                iconColor = SuccessGreen,
                modifier = Modifier.weight(1f)
            )

            DashboardCard(
                title = "Total Purchases",
                value = "₹${(totalPurchases / 1000).toInt()}k",
                icon = Icons.Outlined.ShoppingBag,
                iconBgColor = SecondaryTealLight,
                iconColor = SecondaryTeal,
                modifier = Modifier.weight(1f)
            )
        }

        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            DashboardCard(
                title = "Active Products",
                value = "$totalProducts",
                icon = Icons.Outlined.Inventory2,
                iconBgColor = PrimaryBlueLight,
                iconColor = PrimaryBlue,
                modifier = Modifier.weight(1f)
            )

            DashboardCard(
                title = "Expired Count",
                value = "$expiredCount",
                icon = Icons.Outlined.Warning,
                iconBgColor = AlertRedLight,
                iconColor = AlertRed,
                modifier = Modifier.weight(1f)
            )
        }

        SectionHeader(title = "Monthly Sales vs Purchases (2026)")

        // Interactive Canvas Bar Chart
        Card(
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = SurfaceWhite),
            elevation = CardDefaults.cardElevation(defaultElevation = 2.dp),
            modifier = Modifier
                .fillMaxWidth()
                .border(1.dp, SurfaceBorder, RoundedCornerShape(16.dp))
        ) {
            Column(modifier = Modifier.padding(18.dp)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.End,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Box(modifier = Modifier.size(10.dp).background(SuccessGreen, CircleShape))
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("Sales", fontSize = 11.sp, color = TextSecondary)

                    Spacer(modifier = Modifier.width(12.dp))

                    Box(modifier = Modifier.size(10.dp).background(SecondaryTeal, CircleShape))
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("Purchases", fontSize = 11.sp, color = TextSecondary)
                }

                Spacer(modifier = Modifier.height(16.dp))

                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(180.dp)
                ) {
                    Canvas(modifier = Modifier.fillMaxSize()) {
                        val canvasWidth = size.width
                        val canvasHeight = size.height
                        val maxVal = 220000f

                        val groupWidth = canvasWidth / months.size
                        val barWidth = groupWidth * 0.35f

                        for (i in months.indices) {
                            val groupX = i * groupWidth + (groupWidth - (barWidth * 2 + 8)) / 2

                            // Sales Bar
                            val salesBarHeight = (salesData[i] / maxVal) * (canvasHeight - 30)
                            drawRect(
                                color = SuccessGreen,
                                topLeft = Offset(groupX, canvasHeight - salesBarHeight - 20),
                                size = Size(barWidth, salesBarHeight)
                            )

                            // Purchases Bar
                            val purchaseBarHeight = (purchaseData[i] / maxVal) * (canvasHeight - 30)
                            drawRect(
                                color = SecondaryTeal,
                                topLeft = Offset(groupX + barWidth + 6, canvasHeight - purchaseBarHeight - 20),
                                size = Size(barWidth, purchaseBarHeight)
                            )
                        }
                    }
                }

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceAround
                ) {
                    months.forEach { month ->
                        Text(text = month, fontSize = 11.sp, color = TextSecondary, fontWeight = FontWeight.SemiBold)
                    }
                }
            }
        }
    }
}
