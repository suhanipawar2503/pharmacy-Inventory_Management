package com.example.ui.screens

import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
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
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.ui.components.ConfirmationDialog
import com.example.ui.components.CustomButton
import com.example.ui.theme.*
import com.example.ui.viewmodel.PharmacyViewModel

@Composable
fun ProfileScreen(
    viewModel: PharmacyViewModel,
    onLogout: () -> Unit
) {
    val context = LocalContext.current
    val email by viewModel.userEmail.collectAsState()

    var showLogoutDialog by remember { mutableStateOf(false) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(SurfaceWhite)
            .padding(16.dp)
            .verticalScroll(rememberScrollState()),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Shop Profile Header
        Card(
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = PrimaryBlueLight),
            modifier = Modifier.fillMaxWidth()
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(20.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Box(
                    modifier = Modifier
                        .size(80.dp)
                        .clip(CircleShape)
                        .background(PrimaryBlue),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.Default.LocalPharmacy,
                        contentDescription = "Shop Logo",
                        tint = SurfaceWhite,
                        modifier = Modifier.size(44.dp)
                    )
                }

                Spacer(modifier = Modifier.height(12.dp))

                Text(
                    text = "Smart Care Pharmacy",
                    fontSize = 20.sp,
                    fontWeight = FontWeight.Bold,
                    color = TextPrimary
                )

                Text(
                    text = "License No: 20B/MH-102938",
                    fontSize = 12.sp,
                    color = TextSecondary
                )

                Spacer(modifier = Modifier.height(8.dp))

                Surface(
                    shape = RoundedCornerShape(20.dp),
                    color = PrimaryBlue
                ) {
                    Text(
                        text = "Owner: Dr. Alex Morgan",
                        fontSize = 12.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = SurfaceWhite,
                        modifier = Modifier.padding(horizontal = 12.dp, vertical = 4.dp)
                    )
                }
            }
        }

        // Contact & Shop Info
        Card(
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = SurfaceWhite),
            elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
            modifier = Modifier
                .fillMaxWidth()
                .border(1.dp, SurfaceBorder, RoundedCornerShape(16.dp))
        ) {
            Column(
                modifier = Modifier.padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                Text("Pharmacy Credentials & Contact", fontSize = 14.sp, fontWeight = FontWeight.Bold, color = TextPrimary)

                HorizontalDivider(color = SurfaceBorder)

                ProfileInfoRow(icon = Icons.Outlined.Email, label = "Pharmacist Email", value = email)
                ProfileInfoRow(icon = Icons.Outlined.Phone, label = "Store Contact", value = "+91 98200 44556")
                ProfileInfoRow(icon = Icons.Outlined.LocationOn, label = "Store Address", value = "Plot 12, Healthcare Zone, City Center")
                ProfileInfoRow(icon = Icons.Outlined.Receipt, label = "GSTIN", value = "27ABCDE1234F1Z5")
            }
        }

        // Settings Actions List
        Card(
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = SurfaceWhite),
            elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
            modifier = Modifier
                .fillMaxWidth()
                .border(1.dp, SurfaceBorder, RoundedCornerShape(16.dp))
        ) {
            Column(modifier = Modifier.padding(8.dp)) {
                SettingsOptionItem(
                    icon = Icons.Outlined.Settings,
                    title = "System Settings",
                    subtitle = "Low stock alert threshold, GST configuration",
                    onClick = { Toast.makeText(context, "System Settings Opened", Toast.LENGTH_SHORT).show() }
                )

                HorizontalDivider(color = SurfaceBorder)

                SettingsOptionItem(
                    icon = Icons.Outlined.Backup,
                    title = "Data Backup & Export",
                    subtitle = "Export local dummy database to CSV",
                    onClick = { Toast.makeText(context, "Exporting pharmacy database to CSV...", Toast.LENGTH_SHORT).show() }
                )

                HorizontalDivider(color = SurfaceBorder)

                SettingsOptionItem(
                    icon = Icons.Outlined.HelpOutline,
                    title = "Help & Support",
                    subtitle = "Documentation and user guide",
                    onClick = { Toast.makeText(context, "Smart Pharmacy Help Guide Loaded", Toast.LENGTH_SHORT).show() }
                )
            }
        }

        Spacer(modifier = Modifier.height(8.dp))

        // Logout Button
        CustomButton(
            text = "Logout",
            containerColor = AlertRedLight,
            contentColor = AlertRed,
            icon = Icons.Default.Logout,
            onClick = { showLogoutDialog = true }
        )
    }

    if (showLogoutDialog) {
        ConfirmationDialog(
            title = "Logout from System?",
            message = "Are you sure you want to end your session? You will return to the Login screen.",
            confirmText = "Logout",
            onConfirm = {
                viewModel.logout()
                onLogout()
            },
            onDismiss = { showLogoutDialog = false }
        )
    }
}

@Composable
private fun ProfileInfoRow(
    icon: ImageVector,
    label: String,
    value: String
) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = Modifier.fillMaxWidth()
    ) {
        Icon(imageVector = icon, contentDescription = null, tint = PrimaryBlue, modifier = Modifier.size(20.dp))
        Spacer(modifier = Modifier.width(12.dp))
        Column {
            Text(text = label, fontSize = 11.sp, color = TextSecondary)
            Text(text = value, fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = TextPrimary)
        }
    }
}

@Composable
private fun SettingsOptionItem(
    icon: ImageVector,
    title: String,
    subtitle: String,
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(10.dp))
            .clickable { onClick() }
            .padding(12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(38.dp)
                .clip(CircleShape)
                .background(PrimaryBlueLight),
            contentAlignment = Alignment.Center
        ) {
            Icon(imageVector = icon, contentDescription = null, tint = PrimaryBlue, modifier = Modifier.size(20.dp))
        }

        Spacer(modifier = Modifier.width(12.dp))

        Column(modifier = Modifier.weight(1f)) {
            Text(text = title, fontSize = 14.sp, fontWeight = FontWeight.Bold, color = TextPrimary)
            Text(text = subtitle, fontSize = 12.sp, color = TextSecondary)
        }

        Icon(imageVector = Icons.Default.ChevronRight, contentDescription = null, tint = TextMuted)
    }
}
