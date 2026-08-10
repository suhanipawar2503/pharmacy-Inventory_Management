package com.example.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.outlined.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.ui.components.DashboardCard
import com.example.ui.components.SectionHeader
import com.example.ui.theme.*
import com.example.ui.viewmodel.PharmacyViewModel

@Composable
fun DashboardScreen(
    viewModel: PharmacyViewModel,
    onNavigateToAddProduct: () -> Unit,
    onNavigateToNewSale: () -> Unit,
    onNavigateToNewPurchase: () -> Unit,
    onNavigateToOcrScan: () -> Unit,
    onNavigateToExpiry: () -> Unit,
    onNavigateToInventory: () -> Unit,
    onNavigateToSales: () -> Unit
) {
    val medicines by viewModel.medicines.collectAsState()
    val sales by viewModel.sales.collectAsState()
    val purchases by viewModel.purchases.collectAsState()

    val totalProducts = medicines.size
    val totalStock = medicines.sumOf { it.quantity }
    val lowStockCount = viewModel.getLowStockMedicines(medicines).size
    val expiredCount = viewModel.getExpiredMedicines(medicines).size
    val expiringCount = viewModel.getExpiringIn30DaysMedicines(medicines).size
    val todaySalesTotal = sales.take(15).sumOf { it.grandTotal }

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(SurfaceWhite),
        contentPadding = PaddingValues(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Welcome Pharmacy Banner
        item {
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
                        Text(
                            text = "Smart Care Pharmacy",
                            fontSize = 20.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color.White
                        )
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(
                            text = "System Operational • All Stocks Synchronized",
                            fontSize = 12.sp,
                            color = Color.White.copy(alpha = 0.85f)
                        )
                    }

                    Box(
                        modifier = Modifier
                            .size(44.dp)
                            .clip(CircleShape)
                            .background(Color.White.copy(alpha = 0.2f)),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.LocalPharmacy,
                            contentDescription = null,
                            tint = Color.White,
                            modifier = Modifier.size(26.dp)
                        )
                    }
                }
            }
        }

        // Expiry Alert Banner (if any expired or expiring soon)
        if (expiredCount > 0 || expiringCount > 0) {
            item {
                Card(
                    onClick = onNavigateToExpiry,
                    shape = RoundedCornerShape(14.dp),
                    colors = CardDefaults.cardColors(
                        containerColor = if (expiredCount > 0) AlertRedLight else WarningOrangeLight
                    ),
                    modifier = Modifier
                        .fillMaxWidth()
                        .border(
                            1.dp,
                            if (expiredCount > 0) AlertRed else WarningOrange,
                            RoundedCornerShape(14.dp)
                        )
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(14.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Default.Warning,
                            contentDescription = null,
                            tint = if (expiredCount > 0) AlertRed else WarningOrange,
                            modifier = Modifier.size(28.dp)
                        )

                        Spacer(modifier = Modifier.width(12.dp))

                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                text = "Attention Required",
                                fontSize = 14.sp,
                                fontWeight = FontWeight.Bold,
                                color = if (expiredCount > 0) AlertRed else WarningOrange
                            )
                            Text(
                                text = "$expiredCount Expired • $expiringCount Expiring in 30 Days",
                                fontSize = 12.sp,
                                color = TextPrimary
                            )
                        }

                        Icon(
                            imageVector = Icons.Default.ChevronRight,
                            contentDescription = "View Expiry",
                            tint = TextSecondary
                        )
                    }
                }
            }
        }

        // Overview Cards Grid
        item {
            Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                SectionHeader(title = "Dashboard Overview")

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(10.dp)
                ) {
                    DashboardCard(
                        title = "Total Products",
                        value = "$totalProducts",
                        icon = Icons.Outlined.Inventory2,
                        iconBgColor = PrimaryBlueLight,
                        iconColor = PrimaryBlue,
                        onClick = onNavigateToInventory,
                        modifier = Modifier.weight(1f)
                    )

                    DashboardCard(
                        title = "Total Stock",
                        value = "$totalStock",
                        icon = Icons.Outlined.Category,
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
                        title = "Today's Sales",
                        value = "₹${todaySalesTotal.toInt()}",
                        icon = Icons.Outlined.PointOfSale,
                        iconBgColor = SuccessGreenLight,
                        iconColor = SuccessGreen,
                        onClick = onNavigateToSales,
                        modifier = Modifier.weight(1f)
                    )

                    DashboardCard(
                        title = "Low Stock",
                        value = "$lowStockCount",
                        icon = Icons.Outlined.ProductionQuantityLimits,
                        iconBgColor = AlertRedLight,
                        iconColor = AlertRed,
                        onClick = onNavigateToInventory,
                        modifier = Modifier.weight(1f)
                    )
                }
            }
        }

        // Quick Actions Grid
        item {
            Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                SectionHeader(title = "Quick Actions")

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(10.dp)
                ) {
                    QuickActionButton(
                        title = "Add Product",
                        icon = Icons.Default.AddCircleOutline,
                        color = PrimaryBlue,
                        bgColor = PrimaryBlueLight,
                        onClick = onNavigateToAddProduct,
                        modifier = Modifier.weight(1f)
                    )

                    QuickActionButton(
                        title = "New Sale",
                        icon = Icons.Default.ReceiptLong,
                        color = SuccessGreen,
                        bgColor = SuccessGreenLight,
                        onClick = onNavigateToNewSale,
                        modifier = Modifier.weight(1f)
                    )
                }

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(10.dp)
                ) {
                    QuickActionButton(
                        title = "Add Purchase",
                        icon = Icons.Default.ShoppingBag,
                        color = SecondaryTeal,
                        bgColor = SecondaryTealLight,
                        onClick = onNavigateToNewPurchase,
                        modifier = Modifier.weight(1f)
                    )

                    QuickActionButton(
                        title = "Scan Bill (OCR)",
                        icon = Icons.Default.QrCodeScanner,
                        color = WarningOrange,
                        bgColor = WarningOrangeLight,
                        onClick = onNavigateToOcrScan,
                        modifier = Modifier.weight(1f)
                    )
                }
            }
        }

        // Recent Sales Activity
        item {
            SectionHeader(
                title = "Recent Sales Activity",
                actionText = "View All",
                onActionClick = onNavigateToSales
            )
        }

        items(sales.take(4)) { sale ->
            Card(
                shape = RoundedCornerShape(12.dp),
                colors = CardDefaults.cardColors(containerColor = SurfaceWhite),
                elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
                modifier = Modifier
                    .fillMaxWidth()
                    .border(1.dp, SurfaceBorder, RoundedCornerShape(12.dp))
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Box(
                        modifier = Modifier
                            .size(38.dp)
                            .clip(CircleShape)
                            .background(SuccessGreenLight),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.Receipt,
                            contentDescription = null,
                            tint = SuccessGreen,
                            modifier = Modifier.size(20.dp)
                        )
                    }

                    Spacer(modifier = Modifier.width(12.dp))

                    Column(modifier = Modifier.weight(1f)) {
                        Text(
                            text = sale.invoiceNumber,
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            color = TextPrimary
                        )
                        Text(
                            text = "${sale.customerName} • ${sale.items.size} item(s) • ${sale.paymentMode}",
                            fontSize = 12.sp,
                            color = TextSecondary,
                            maxLines = 1,
                            overflow = TextOverflow.Ellipsis
                        )
                    }

                    Column(horizontalAlignment = Alignment.End) {
                        Text(
                            text = "₹${sale.grandTotal}",
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            color = SuccessGreen
                        )
                        Text(
                            text = sale.saleDate,
                            fontSize = 11.sp,
                            color = TextMuted
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun QuickActionButton(
    title: String,
    icon: ImageVector,
    color: Color,
    bgColor: Color,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Card(
        onClick = onClick,
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = SurfaceWhite),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
        modifier = modifier
            .fillMaxWidth()
            .border(1.dp, SurfaceBorder, RoundedCornerShape(14.dp))
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(14.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Box(
                modifier = Modifier
                    .size(44.dp)
                    .clip(CircleShape)
                    .background(bgColor),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = icon,
                    contentDescription = null,
                    tint = color,
                    modifier = Modifier.size(24.dp)
                )
            }
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = title,
                fontSize = 13.sp,
                fontWeight = FontWeight.SemiBold,
                color = TextPrimary
            )
        }
    }
}
