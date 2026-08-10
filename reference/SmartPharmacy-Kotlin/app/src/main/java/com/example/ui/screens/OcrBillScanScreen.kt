package com.example.ui.screens

import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.model.PurchaseRecord
import com.example.ui.components.CustomButton
import com.example.ui.components.CustomTextField
import com.example.ui.theme.*
import com.example.ui.viewmodel.PharmacyViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun OcrBillScanScreen(
    viewModel: PharmacyViewModel,
    onNavigateBack: () -> Unit
) {
    val context = LocalContext.current
    val distributors by viewModel.distributors.collectAsState()

    var isScanSimulated by remember { mutableStateOf(false) }

    // Extracted Editable Fields
    var medicineName by remember { mutableStateOf("Azithromycin 500mg") }
    var quantityStr by remember { mutableStateOf("100") }
    var purchasePriceStr by remember { mutableStateOf("58.0") }
    var expiryDate by remember { mutableStateOf("2028-11-30") }
    var distributorName by remember { mutableStateOf(distributors.firstOrNull()?.name ?: "MedLife Wholesale Traders") }
    var invoiceNumber by remember { mutableStateOf("INV-OCR-9921") }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Smart OCR Bill Scanner", fontWeight = FontWeight.Bold) },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(imageVector = Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = SurfaceWhite)
            )
        },
        containerColor = SurfaceWhite
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(16.dp)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Camera / Image Scanner Frame
            Card(
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = SurfaceCard),
                modifier = Modifier
                    .fillMaxWidth()
                    .height(200.dp)
                    .border(2.dp, PrimaryBlue, RoundedCornerShape(16.dp))
            ) {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Box(
                            modifier = Modifier
                                .size(64.dp)
                                .clip(CircleShape)
                                .background(PrimaryBlueLight),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                imageVector = if (isScanSimulated) Icons.Default.CheckCircle else Icons.Default.PhotoCamera,
                                contentDescription = null,
                                tint = if (isScanSimulated) SuccessGreen else PrimaryBlue,
                                modifier = Modifier.size(36.dp)
                            )
                        }

                        Spacer(modifier = Modifier.height(10.dp))

                        Text(
                            text = if (isScanSimulated) "Invoice Scanned & Text Recognized!" else "Position supplier invoice bill inside frame",
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            color = TextPrimary
                        )

                        Text(
                            text = if (isScanSimulated) "Review recognized text fields below" else "OCR powered document scanner",
                            fontSize = 12.sp,
                            color = TextSecondary
                        )
                    }
                }
            }

            // Buttons: Open Camera & Upload Image
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                Button(
                    onClick = {
                        isScanSimulated = true
                        Toast.makeText(context, "Simulated Camera Capture • Text Extracted!", Toast.LENGTH_SHORT).show()
                    },
                    colors = ButtonDefaults.buttonColors(containerColor = PrimaryBlue),
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier
                        .weight(1f)
                        .height(48.dp)
                ) {
                    Icon(imageVector = Icons.Default.CameraAlt, contentDescription = null, modifier = Modifier.size(18.dp))
                    Spacer(modifier = Modifier.width(6.dp))
                    Text("Open Camera")
                }

                OutlinedButton(
                    onClick = {
                        isScanSimulated = true
                        Toast.makeText(context, "Invoice Image Uploaded • Text Extracted!", Toast.LENGTH_SHORT).show()
                    },
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier
                        .weight(1f)
                        .height(48.dp)
                ) {
                    Icon(imageVector = Icons.Default.UploadFile, contentDescription = null, modifier = Modifier.size(18.dp))
                    Spacer(modifier = Modifier.width(6.dp))
                    Text("Upload Invoice")
                }
            }

            // Recognized Text Section Header
            Card(
                shape = RoundedCornerShape(12.dp),
                colors = CardDefaults.cardColors(containerColor = PrimaryBlueLight),
                modifier = Modifier.fillMaxWidth()
            ) {
                Row(
                    modifier = Modifier.padding(12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(imageVector = Icons.Default.AutoFixHigh, contentDescription = null, tint = PrimaryBlue)
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = "OCR Recognized Data (Verify & Edit)",
                        fontWeight = FontWeight.Bold,
                        fontSize = 13.sp,
                        color = PrimaryBlueDark
                    )
                }
            }

            // Editable Fields
            CustomTextField(
                value = medicineName,
                onValueChange = { medicineName = it },
                label = "Recognized Medicine Name",
                leadingIcon = Icons.Default.Medication
            )

            CustomTextField(
                value = distributorName,
                onValueChange = { distributorName = it },
                label = "Recognized Supplier / Distributor",
                leadingIcon = Icons.Default.LocalShipping
            )

            CustomTextField(
                value = invoiceNumber,
                onValueChange = { invoiceNumber = it },
                label = "Recognized Invoice #",
                leadingIcon = Icons.Default.Receipt
            )

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                CustomTextField(
                    value = quantityStr,
                    onValueChange = { quantityStr = it },
                    label = "Quantity",
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.weight(1f)
                )

                CustomTextField(
                    value = purchasePriceStr,
                    onValueChange = { purchasePriceStr = it },
                    label = "Purchase Price (₹)",
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.weight(1f)
                )
            }

            CustomTextField(
                value = expiryDate,
                onValueChange = { expiryDate = it },
                label = "Batch Expiry Date",
                leadingIcon = Icons.Default.CalendarToday
            )

            Spacer(modifier = Modifier.height(12.dp))

            CustomButton(
                text = "Save Purchase to Inventory",
                containerColor = SuccessGreen,
                onClick = {
                    val qty = quantityStr.toIntOrNull() ?: 50
                    val price = purchasePriceStr.toDoubleOrNull() ?: 50.0

                    val record = PurchaseRecord(
                        id = "P" + System.currentTimeMillis().toString().takeLast(4),
                        invoiceNumber = invoiceNumber,
                        distributorName = distributorName,
                        purchaseDate = "2026-07-25",
                        medicineId = "M03",
                        medicineName = medicineName,
                        quantity = qty,
                        purchasePrice = price,
                        expiryDate = expiryDate,
                        totalAmount = qty * price
                    )

                    viewModel.addPurchase(record)
                    Toast.makeText(context, "Scanned Bill saved! Stock increased by $qty units.", Toast.LENGTH_LONG).show()
                    onNavigateBack()
                }
            )
        }
    }
}
