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
import com.example.data.model.SaleItem
import com.example.data.model.SaleRecord
import com.example.ui.components.CustomButton
import com.example.ui.components.CustomSearchBar
import com.example.ui.components.CustomTextField
import com.example.ui.theme.*
import com.example.ui.viewmodel.PharmacyViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SalesListScreen(
    viewModel: PharmacyViewModel,
    onNavigateToCreateBill: () -> Unit,
    onNavigateToInvoice: (String) -> Unit
) {
    val sales by viewModel.sales.collectAsState()
    val searchQuery by viewModel.salesSearch.collectAsState()

    val filtered = remember(sales, searchQuery) {
        sales.filter {
            it.invoiceNumber.contains(searchQuery, ignoreCase = true) ||
                    it.customerName.contains(searchQuery, ignoreCase = true) ||
                    it.paymentMode.contains(searchQuery, ignoreCase = true)
        }
    }

    Scaffold(
        floatingActionButton = {
            FloatingActionButton(
                onClick = onNavigateToCreateBill,
                containerColor = SuccessGreen,
                contentColor = SurfaceWhite,
                shape = RoundedCornerShape(16.dp),
                modifier = Modifier.testTag("fab_create_bill")
            ) {
                Row(
                    modifier = Modifier.padding(horizontal = 16.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(imageVector = Icons.Default.ReceiptLong, contentDescription = "Create Bill")
                    Spacer(modifier = Modifier.width(6.dp))
                    Text("Create Bill", fontWeight = FontWeight.Bold)
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
                onQueryChange = { viewModel.setSalesSearch(it) },
                placeholder = "Search invoice #, customer name..."
            )

            Spacer(modifier = Modifier.height(12.dp))

            Text(
                text = "Billing Records (${filtered.size})",
                fontSize = 14.sp,
                fontWeight = FontWeight.Bold,
                color = TextPrimary
            )

            Spacer(modifier = Modifier.height(8.dp))

            LazyColumn(
                verticalArrangement = Arrangement.spacedBy(10.dp),
                contentPadding = PaddingValues(bottom = 80.dp)
            ) {
                items(filtered, key = { it.id }) { sale ->
                    Card(
                        onClick = { onNavigateToInvoice(sale.id) },
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
                                    .background(SuccessGreenLight),
                                contentAlignment = Alignment.Center
                            ) {
                                Icon(
                                    imageVector = Icons.Default.PointOfSale,
                                    contentDescription = null,
                                    tint = SuccessGreen,
                                    modifier = Modifier.size(22.dp)
                                )
                            }

                            Spacer(modifier = Modifier.width(12.dp))

                            Column(modifier = Modifier.weight(1f)) {
                                Text(
                                    text = sale.invoiceNumber,
                                    fontSize = 15.sp,
                                    fontWeight = FontWeight.Bold,
                                    color = TextPrimary
                                )
                                Text(
                                    text = "${sale.customerName} • ${sale.paymentMode}",
                                    fontSize = 12.sp,
                                    color = TextSecondary
                                )
                                Text(
                                    text = "${sale.saleDate} • ${sale.items.size} item(s)",
                                    fontSize = 11.sp,
                                    color = TextMuted
                                )
                            }

                            Spacer(modifier = Modifier.width(8.dp))

                            Text(
                                text = "₹${sale.grandTotal}",
                                fontSize = 16.sp,
                                fontWeight = FontWeight.Bold,
                                color = SuccessGreen
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
fun CreateBillScreen(
    viewModel: PharmacyViewModel,
    onNavigateToGeneratedInvoice: (String) -> Unit,
    onNavigateBack: () -> Unit
) {
    val context = LocalContext.current
    val medicines by viewModel.medicines.collectAsState()

    var customerName by remember { mutableStateOf("Walk-in Customer") }
    var selectedPaymentMode by remember { mutableStateOf("UPI") }

    val cartItems = remember { mutableStateListOf<SaleItem>() }

    var selectedMedName by remember { mutableStateOf(medicines.firstOrNull()?.name ?: "") }
    var quantityStr by remember { mutableStateOf("1") }
    var medExpanded by remember { mutableStateOf(false) }

    val grandTotal = cartItems.sumOf { it.itemTotal }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Create New Bill", fontWeight = FontWeight.Bold) },
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
            CustomTextField(
                value = customerName,
                onValueChange = { customerName = it },
                label = "Customer Name",
                leadingIcon = Icons.Default.Person
            )

            // Add Medicine to Cart Box
            Card(
                shape = RoundedCornerShape(14.dp),
                colors = CardDefaults.cardColors(containerColor = SurfaceCard),
                modifier = Modifier.fillMaxWidth()
            ) {
                Column(
                    modifier = Modifier.padding(14.dp),
                    verticalArrangement = Arrangement.spacedBy(10.dp)
                ) {
                    Text("Add Medicine to Bill", fontWeight = FontWeight.Bold, fontSize = 14.sp)

                    ExposedDropdownMenuBox(
                        expanded = medExpanded,
                        onExpandedChange = { medExpanded = !medExpanded }
                    ) {
                        CustomTextField(
                            value = selectedMedName,
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
                                    text = { Text("${med.name} (Stock: ${med.quantity}) - ₹${med.sellingPrice}") },
                                    onClick = {
                                        selectedMedName = med.name
                                        medExpanded = false
                                    }
                                )
                            }
                        }
                    }

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(10.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        CustomTextField(
                            value = quantityStr,
                            onValueChange = { quantityStr = it },
                            label = "Qty",
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                            modifier = Modifier.weight(1f)
                        )

                        Button(
                            onClick = {
                                val targetMed = medicines.find { it.name.equals(selectedMedName, ignoreCase = true) }
                                if (targetMed != null) {
                                    val qty = quantityStr.toIntOrNull() ?: 1
                                    if (qty > targetMed.quantity) {
                                        Toast.makeText(context, "Only ${targetMed.quantity} units available in stock!", Toast.LENGTH_SHORT).show()
                                        return@Button
                                    }
                                    val item = SaleItem(
                                        medicineId = targetMed.id,
                                        medicineName = targetMed.name,
                                        quantity = qty,
                                        unitPrice = targetMed.sellingPrice
                                    )
                                    cartItems.add(item)
                                    Toast.makeText(context, "${targetMed.name} added to bill", Toast.LENGTH_SHORT).show()
                                }
                            },
                            colors = ButtonDefaults.buttonColors(containerColor = PrimaryBlue),
                            shape = RoundedCornerShape(12.dp),
                            modifier = Modifier.height(52.dp)
                        ) {
                            Icon(imageVector = Icons.Default.Add, contentDescription = null)
                            Spacer(modifier = Modifier.width(4.dp))
                            Text("Add Item")
                        }
                    }
                }
            }

            // Items List Table
            Text("Bill Items (${cartItems.size})", fontWeight = FontWeight.Bold, fontSize = 15.sp)

            if (cartItems.isEmpty()) {
                Surface(
                    shape = RoundedCornerShape(12.dp),
                    color = SurfaceCard,
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Box(modifier = Modifier.padding(24.dp), contentAlignment = Alignment.Center) {
                        Text("No items added to bill yet", color = TextMuted, fontSize = 13.sp)
                    }
                }
            } else {
                Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    cartItems.forEachIndexed { index, item ->
                        Card(
                            shape = RoundedCornerShape(12.dp),
                            colors = CardDefaults.cardColors(containerColor = SurfaceWhite),
                            modifier = Modifier
                                .fillMaxWidth()
                                .border(1.dp, SurfaceBorder, RoundedCornerShape(12.dp))
                        ) {
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(12.dp),
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.SpaceBetween
                            ) {
                                Column(modifier = Modifier.weight(1f)) {
                                    Text(item.medicineName, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                                    Text("${item.quantity} x ₹${item.unitPrice}", fontSize = 12.sp, color = TextSecondary)
                                }
                                Text("₹${item.itemTotal}", fontWeight = FontWeight.Bold, fontSize = 14.sp, color = SuccessGreen)
                                IconButton(onClick = { cartItems.removeAt(index) }) {
                                    Icon(imageVector = Icons.Default.Delete, contentDescription = "Remove", tint = AlertRed)
                                }
                            }
                        }
                    }
                }
            }

            // Payment Mode Selector
            Text("Payment Method", fontWeight = FontWeight.Bold, fontSize = 14.sp)

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                listOf("UPI", "Cash", "Card").forEach { mode ->
                    val isSelected = selectedPaymentMode == mode
                    FilterChip(
                        selected = isSelected,
                        onClick = { selectedPaymentMode = mode },
                        label = { Text(mode, fontWeight = FontWeight.Bold) },
                        colors = FilterChipDefaults.filterChipColors(
                            selectedContainerColor = SuccessGreen,
                            selectedLabelColor = SurfaceWhite
                        ),
                        modifier = Modifier.weight(1f)
                    )
                }
            }

            // Total Summary Card
            Card(
                shape = RoundedCornerShape(14.dp),
                colors = CardDefaults.cardColors(containerColor = SuccessGreenLight),
                modifier = Modifier.fillMaxWidth()
            ) {
                Row(
                    modifier = Modifier.padding(18.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("Grand Total Amount:", fontWeight = FontWeight.Bold, fontSize = 15.sp)
                    Text("₹${String.format("%.2f", grandTotal)}", fontWeight = FontWeight.Bold, fontSize = 22.sp, color = SuccessGreen)
                }
            }

            Spacer(modifier = Modifier.height(12.dp))

            CustomButton(
                text = "Generate Invoice & Finalize Sale",
                containerColor = SuccessGreen,
                enabled = cartItems.isNotEmpty(),
                onClick = {
                    val invoiceNo = "INV-SL-2026-" + (5000..9999).random()
                    val saleRecord = SaleRecord(
                        id = "S" + System.currentTimeMillis().toString().takeLast(4),
                        invoiceNumber = invoiceNo,
                        saleDate = "2026-07-25",
                        items = cartItems.toList(),
                        grandTotal = grandTotal,
                        customerName = customerName.ifBlank { "Walk-in Customer" },
                        paymentMode = selectedPaymentMode
                    )

                    viewModel.addSale(saleRecord)
                    Toast.makeText(context, "Invoice Generated! Stock reduced automatically.", Toast.LENGTH_LONG).show()
                    onNavigateToGeneratedInvoice(saleRecord.id)
                }
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun InvoiceScreen(
    viewModel: PharmacyViewModel,
    saleId: String,
    onNavigateBack: () -> Unit
) {
    val context = LocalContext.current
    val sales by viewModel.sales.collectAsState()
    val sale = sales.find { it.id == saleId }

    if (sale == null) {
        Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            Text("Invoice not found")
        }
        return
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Official Tax Invoice", fontWeight = FontWeight.Bold) },
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
            // Printable Invoice Card Paper
            Card(
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = SurfaceWhite),
                elevation = CardDefaults.cardElevation(defaultElevation = 2.dp),
                modifier = Modifier
                    .fillMaxWidth()
                    .border(1.dp, SurfaceBorder, RoundedCornerShape(16.dp))
            ) {
                Column(
                    modifier = Modifier.padding(20.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    // Pharmacy Header
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Column {
                            Text("Smart Care Pharmacy", fontSize = 18.sp, fontWeight = FontWeight.Bold, color = PrimaryBlue)
                            Text("Licensed Retail Chemist • DL: 20B/112233", fontSize = 11.sp, color = TextSecondary)
                            Text("MG Road, Healthcare Complex, City", fontSize = 11.sp, color = TextSecondary)
                        }
                        Surface(shape = RoundedCornerShape(8.dp), color = SuccessGreenLight) {
                            Text("PAID", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = SuccessGreen, modifier = Modifier.padding(horizontal = 10.dp, vertical = 4.dp))
                        }
                    }

                    HorizontalDivider(color = SurfaceBorder)

                    // Invoice Metadata
                    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                        Column {
                            Text("Invoice No:", fontSize = 12.sp, color = TextSecondary)
                            Text(sale.invoiceNumber, fontSize = 14.sp, fontWeight = FontWeight.Bold)
                        }
                        Column(horizontalAlignment = Alignment.End) {
                            Text("Date & Payment Mode:", fontSize = 12.sp, color = TextSecondary)
                            Text("${sale.saleDate} • ${sale.paymentMode}", fontSize = 13.sp, fontWeight = FontWeight.SemiBold)
                        }
                    }

                    Text("Customer: ${sale.customerName}", fontSize = 13.sp, fontWeight = FontWeight.Medium, color = TextPrimary)

                    HorizontalDivider(color = SurfaceBorder)

                    // Items Header
                    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                        Text("Item / Medicine", fontWeight = FontWeight.Bold, fontSize = 12.sp, modifier = Modifier.weight(2f))
                        Text("Qty", fontWeight = FontWeight.Bold, fontSize = 12.sp, modifier = Modifier.weight(0.8f))
                        Text("Price", fontWeight = FontWeight.Bold, fontSize = 12.sp, modifier = Modifier.weight(1f))
                        Text("Total", fontWeight = FontWeight.Bold, fontSize = 12.sp, modifier = Modifier.weight(1f))
                    }

                    HorizontalDivider(color = SurfaceBorder)

                    sale.items.forEach { item ->
                        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                            Text(item.medicineName, fontSize = 13.sp, modifier = Modifier.weight(2f))
                            Text("${item.quantity}", fontSize = 13.sp, modifier = Modifier.weight(0.8f))
                            Text("₹${item.unitPrice}", fontSize = 13.sp, modifier = Modifier.weight(1f))
                            Text("₹${item.itemTotal}", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, modifier = Modifier.weight(1f))
                        }
                    }

                    HorizontalDivider(color = SurfaceBorder)

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text("Grand Total Amount", fontSize = 16.sp, fontWeight = FontWeight.Bold)
                        Text("₹${sale.grandTotal}", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = SuccessGreen)
                    }

                    Spacer(modifier = Modifier.height(4.dp))
                    Text("Thank you for choosing Smart Care Pharmacy!", fontSize = 11.sp, color = TextMuted, modifier = Modifier.align(Alignment.CenterHorizontally))
                }
            }

            // Action Buttons (Save, Share, Print UI only)
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Button(
                    onClick = { Toast.makeText(context, "Invoice Saved to PDF Device Storage", Toast.LENGTH_SHORT).show() },
                    colors = ButtonDefaults.buttonColors(containerColor = PrimaryBlue),
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier
                        .weight(1f)
                        .height(48.dp)
                ) {
                    Icon(imageVector = Icons.Default.Save, contentDescription = null, modifier = Modifier.size(18.dp))
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("Save PDF")
                }

                OutlinedButton(
                    onClick = { Toast.makeText(context, "Sharing Invoice via WhatsApp / Mail", Toast.LENGTH_SHORT).show() },
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier
                        .weight(1f)
                        .height(48.dp)
                ) {
                    Icon(imageVector = Icons.Default.Share, contentDescription = null, modifier = Modifier.size(18.dp))
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("Share")
                }

                OutlinedButton(
                    onClick = { Toast.makeText(context, "Sending PDF to Thermal Receipt Printer", Toast.LENGTH_SHORT).show() },
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier
                        .weight(1f)
                        .height(48.dp)
                ) {
                    Icon(imageVector = Icons.Default.Print, contentDescription = null, modifier = Modifier.size(18.dp))
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("Print")
                }
            }
        }
    }
}
