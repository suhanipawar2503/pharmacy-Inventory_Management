package com.example.ui.screens

import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
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
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.model.PurchaseRecord
import com.example.ui.components.CustomButton
import com.example.ui.components.CustomSearchBar
import com.example.ui.components.CustomTextField
import com.example.ui.theme.*
import com.example.ui.viewmodel.PharmacyViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PurchaseListScreen(
    viewModel: PharmacyViewModel,
    onNavigateToAddPurchase: () -> Unit,
    onNavigateToPurchaseDetails: (String) -> Unit
) {
    val purchases by viewModel.purchases.collectAsState()
    val searchQuery by viewModel.purchaseSearch.collectAsState()

    val filteredPurchases = remember(purchases, searchQuery) {
        purchases.filter {
            it.invoiceNumber.contains(searchQuery, ignoreCase = true) ||
                    it.distributorName.contains(searchQuery, ignoreCase = true) ||
                    it.medicineName.contains(searchQuery, ignoreCase = true)
        }
    }

    Scaffold(
        floatingActionButton = {
            FloatingActionButton(
                onClick = onNavigateToAddPurchase,
                containerColor = SecondaryTeal,
                contentColor = SurfaceWhite,
                shape = RoundedCornerShape(16.dp),
                modifier = Modifier.testTag("fab_add_purchase")
            ) {
                Row(
                    modifier = Modifier.padding(horizontal = 16.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(imageVector = Icons.Default.Add, contentDescription = "Add Purchase")
                    Spacer(modifier = Modifier.width(6.dp))
                    Text("Add Purchase", fontWeight = FontWeight.Bold)
                }
            }
        },
        containerColor = SurfaceWhite
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(horizontal = 16.dp)
        ) {
            Spacer(modifier = Modifier.height(12.dp))

            CustomSearchBar(
                query = searchQuery,
                onQueryChange = { viewModel.setPurchaseSearch(it) },
                placeholder = "Search invoice, distributor, medicine..."
            )

            Spacer(modifier = Modifier.height(12.dp))

            Text(
                text = "Total Purchases (${filteredPurchases.size})",
                fontSize = 14.sp,
                fontWeight = FontWeight.Bold,
                color = TextPrimary
            )

            Spacer(modifier = Modifier.height(8.dp))

            LazyColumn(
                verticalArrangement = Arrangement.spacedBy(10.dp),
                contentPadding = PaddingValues(bottom = 80.dp)
            ) {
                items(filteredPurchases, key = { it.id }) { purchase ->
                    Card(
                        onClick = { onNavigateToPurchaseDetails(purchase.id) },
                        shape = RoundedCornerShape(14.dp),
                        colors = CardDefaults.cardColors(containerColor = SurfaceWhite),
                        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
                        modifier = Modifier
                            .fillMaxWidth()
                            .border(1.dp, SurfaceBorder, RoundedCornerShape(14.dp))
                    ) {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(14.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Box(
                                modifier = Modifier
                                    .size(44.dp)
                                    .clip(CircleShape)
                                    .background(SecondaryTealLight),
                                contentAlignment = Alignment.Center
                            ) {
                                Icon(
                                    imageVector = Icons.Default.ShoppingBag,
                                    contentDescription = null,
                                    tint = SecondaryTeal,
                                    modifier = Modifier.size(22.dp)
                                )
                            }

                            Spacer(modifier = Modifier.width(12.dp))

                            Column(modifier = Modifier.weight(1f)) {
                                Text(
                                    text = purchase.medicineName,
                                    fontSize = 15.sp,
                                    fontWeight = FontWeight.Bold,
                                    color = TextPrimary,
                                    maxLines = 1,
                                    overflow = TextOverflow.Ellipsis
                                )
                                Text(
                                    text = "${purchase.distributorName} • ${purchase.invoiceNumber}",
                                    fontSize = 12.sp,
                                    color = TextSecondary,
                                    maxLines = 1,
                                    overflow = TextOverflow.Ellipsis
                                )
                                Text(
                                    text = "Date: ${purchase.purchaseDate} • Qty: ${purchase.quantity}",
                                    fontSize = 11.sp,
                                    color = TextMuted
                                )
                            }

                            Spacer(modifier = Modifier.width(8.dp))

                            Text(
                                text = "₹${purchase.totalAmount.toInt()}",
                                fontSize = 15.sp,
                                fontWeight = FontWeight.Bold,
                                color = SecondaryTeal
                            )
                        }
                    }
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddPurchaseScreen(
    viewModel: PharmacyViewModel,
    onNavigateBack: () -> Unit
) {
    val context = LocalContext.current
    val distributors by viewModel.distributors.collectAsState()
    val medicines by viewModel.medicines.collectAsState()

    var selectedDistributor by remember { mutableStateOf(distributors.firstOrNull()?.name ?: "MedLife Wholesale") }
    var selectedMedicine by remember { mutableStateOf(medicines.firstOrNull()?.name ?: "Amoxicillin 500mg") }
    var invoiceNumber by remember { mutableStateOf("INV-PUR-2026-" + (1000..9999).random()) }
    var purchaseDate by remember { mutableStateOf("2026-07-25") }
    var quantityStr by remember { mutableStateOf("50") }
    var purchasePriceStr by remember { mutableStateOf("35.0") }
    var expiryDate by remember { mutableStateOf("2028-06-30") }

    var distExpanded by remember { mutableStateOf(false) }
    var medExpanded by remember { mutableStateOf(false) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("New Purchase Order", fontWeight = FontWeight.Bold) },
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
            verticalArrangement = Arrangement.spacedBy(14.dp)
        ) {
            // Distributor Selection
            ExposedDropdownMenuBox(
                expanded = distExpanded,
                onExpandedChange = { distExpanded = !distExpanded }
            ) {
                CustomTextField(
                    value = selectedDistributor,
                    onValueChange = {},
                    label = "Distributor / Supplier",
                    leadingIcon = Icons.Default.LocalShipping,
                    trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = distExpanded) },
                    modifier = Modifier.menuAnchor()
                )

                ExposedDropdownMenu(
                    expanded = distExpanded,
                    onDismissRequest = { distExpanded = false },
                    modifier = Modifier.background(SurfaceWhite)
                ) {
                    distributors.forEach { dist ->
                        DropdownMenuItem(
                            text = { Text(dist.name) },
                            onClick = {
                                selectedDistributor = dist.name
                                distExpanded = false
                            }
                        )
                    }
                }
            }

            CustomTextField(
                value = invoiceNumber,
                onValueChange = { invoiceNumber = it },
                label = "Invoice Number",
                leadingIcon = Icons.Default.Receipt
            )

            // Medicine Selection
            ExposedDropdownMenuBox(
                expanded = medExpanded,
                onExpandedChange = { medExpanded = !medExpanded }
            ) {
                CustomTextField(
                    value = selectedMedicine,
                    onValueChange = {},
                    label = "Select Medicine",
                    leadingIcon = Icons.Default.Medication,
                    trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = medExpanded) },
                    modifier = Modifier.menuAnchor()
                )

                ExposedDropdownMenu(
                    expanded = medExpanded,
                    onDismissRequest = { medExpanded = false },
                    modifier = Modifier.background(SurfaceWhite)
                ) {
                    medicines.forEach { med ->
                        DropdownMenuItem(
                            text = { Text("${med.name} (${med.company})") },
                            onClick = {
                                selectedMedicine = med.name
                                purchasePriceStr = med.purchasePrice.toString()
                                medExpanded = false
                            }
                        )
                    }
                }
            }

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                CustomTextField(
                    value = quantityStr,
                    onValueChange = { quantityStr = it },
                    label = "Quantity Purchased",
                    placeholder = "50",
                    leadingIcon = Icons.Default.FormatListNumbered,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.weight(1f)
                )

                CustomTextField(
                    value = purchasePriceStr,
                    onValueChange = { purchasePriceStr = it },
                    label = "Purchase Price (₹)",
                    placeholder = "35.0",
                    leadingIcon = Icons.Default.AttachMoney,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.weight(1f)
                )
            }

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                CustomTextField(
                    value = purchaseDate,
                    onValueChange = { purchaseDate = it },
                    label = "Purchase Date",
                    leadingIcon = Icons.Default.CalendarToday,
                    modifier = Modifier.weight(1f)
                )

                CustomTextField(
                    value = expiryDate,
                    onValueChange = { expiryDate = it },
                    label = "Batch Expiry",
                    leadingIcon = Icons.Default.Event,
                    modifier = Modifier.weight(1f)
                )
            }

            val qty = quantityStr.toIntOrNull() ?: 0
            val price = purchasePriceStr.toDoubleOrNull() ?: 0.0
            val total = qty * price

            Card(
                shape = RoundedCornerShape(12.dp),
                colors = CardDefaults.cardColors(containerColor = SecondaryTealLight),
                modifier = Modifier.fillMaxWidth()
            ) {
                Row(
                    modifier = Modifier.padding(16.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("Total Invoice Amount:", fontWeight = FontWeight.Bold, fontSize = 14.sp)
                    Text("₹${String.format("%.2f", total)}", fontWeight = FontWeight.Bold, fontSize = 18.sp, color = SecondaryTeal)
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            CustomButton(
                text = "Save Purchase & Update Stock",
                containerColor = SecondaryTeal,
                onClick = {
                    val targetMed = medicines.find { it.name.equals(selectedMedicine, ignoreCase = true) }
                    val medId = targetMed?.id ?: "M01"

                    val record = PurchaseRecord(
                        id = "P" + System.currentTimeMillis().toString().takeLast(4),
                        invoiceNumber = invoiceNumber,
                        distributorName = selectedDistributor,
                        purchaseDate = purchaseDate,
                        medicineId = medId,
                        medicineName = selectedMedicine,
                        quantity = qty,
                        purchasePrice = price,
                        expiryDate = expiryDate,
                        totalAmount = total
                    )

                    viewModel.addPurchase(record)
                    Toast.makeText(context, "Purchase saved! Medicine stock increased by $qty", Toast.LENGTH_LONG).show()
                    onNavigateBack()
                }
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PurchaseDetailsScreen(
    viewModel: PharmacyViewModel,
    purchaseId: String,
    onNavigateBack: () -> Unit
) {
    val purchases by viewModel.purchases.collectAsState()
    val purchase = purchases.find { it.id == purchaseId }

    if (purchase == null) {
        Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            Text("Purchase record not found")
        }
        return
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Purchase Details", fontWeight = FontWeight.Bold) },
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
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Card(
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = SecondaryTealLight),
                modifier = Modifier.fillMaxWidth()
            ) {
                Column(modifier = Modifier.padding(20.dp)) {
                    Text(text = "Invoice: ${purchase.invoiceNumber}", fontSize = 18.sp, fontWeight = FontWeight.Bold, color = SecondaryTeal)
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(text = "Supplier: ${purchase.distributorName}", fontSize = 14.sp, color = TextPrimary)
                }
            }

            Card(
                shape = RoundedCornerShape(14.dp),
                colors = CardDefaults.cardColors(containerColor = SurfaceWhite),
                elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
                modifier = Modifier
                    .fillMaxWidth()
                    .border(1.dp, SurfaceBorder, RoundedCornerShape(14.dp))
            ) {
                Column(
                    modifier = Modifier.padding(18.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    DetailItem(label = "Medicine Name", value = purchase.medicineName)
                    DetailItem(label = "Purchase Date", value = purchase.purchaseDate)
                    DetailItem(label = "Quantity Received", value = "${purchase.quantity} units")
                    DetailItem(label = "Unit Purchase Price", value = "₹${purchase.purchasePrice}")
                    DetailItem(label = "Batch Expiry Date", value = purchase.expiryDate)
                    HorizontalDivider(color = SurfaceBorder)
                    DetailItem(label = "Grand Total Amount", value = "₹${purchase.totalAmount}", isBold = true, valueColor = SecondaryTeal)
                }
            }
        }
    }
}

@Composable
private fun DetailItem(
    label: String,
    value: String,
    isBold: Boolean = false,
    valueColor: Color = TextPrimary
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(text = label, fontSize = 13.sp, color = TextSecondary)
        Text(
            text = value,
            fontSize = 14.sp,
            fontWeight = if (isBold) FontWeight.Bold else FontWeight.SemiBold,
            color = valueColor
        )
    }
}
