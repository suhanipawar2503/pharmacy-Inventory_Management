package com.example.ui.screens

import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
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
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.model.Medicine
import com.example.ui.components.CustomButton
import com.example.ui.components.CustomTextField
import com.example.ui.theme.*
import com.example.ui.viewmodel.PharmacyViewModel
import java.util.UUID

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddEditProductScreen(
    viewModel: PharmacyViewModel,
    medicineIdToEdit: String? = null,
    onNavigateBack: () -> Unit
) {
    val context = LocalContext.current
    val medicines by viewModel.medicines.collectAsState()
    val distributors by viewModel.distributors.collectAsState()

    val existingMedicine = remember(medicineIdToEdit, medicines) {
        if (medicineIdToEdit != null) medicines.find { it.id == medicineIdToEdit } else null
    }

    var name by remember { mutableStateOf(existingMedicine?.name ?: "") }
    var company by remember { mutableStateOf(existingMedicine?.company ?: "") }
    var category by remember { mutableStateOf(existingMedicine?.category ?: "Antibiotics") }
    var batchNumber by remember { mutableStateOf(existingMedicine?.batchNumber ?: "BAT-2026-01") }
    var purchasePriceStr by remember { mutableStateOf(existingMedicine?.purchasePrice?.toString() ?: "") }
    var sellingPriceStr by remember { mutableStateOf(existingMedicine?.sellingPrice?.toString() ?: "") }
    var quantityStr by remember { mutableStateOf(existingMedicine?.quantity?.toString() ?: "50") }
    var expiryDate by remember { mutableStateOf(existingMedicine?.expiryDate ?: "2027-12-31") }
    var selectedDistributor by remember {
        mutableStateOf(existingMedicine?.distributorName ?: (distributors.firstOrNull()?.name ?: "MedLife Wholesale"))
    }

    var categoryExpanded by remember { mutableStateOf(false) }
    var distributorExpanded by remember { mutableStateOf(false) }

    val categoryList = listOf("Antibiotics", "Analgesics", "Cardiovascular", "Antidiabetic", "Gastrointestinal", "Vitamins & Supplements", "Respiratory", "Dermatology", "Neurology", "Nutritional")

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        text = if (existingMedicine == null) "Add New Product" else "Edit Product",
                        fontWeight = FontWeight.Bold
                    )
                },
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
            // Medicine Image Placeholder Box
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(110.dp)
                    .clip(RoundedCornerShape(14.dp))
                    .background(PrimaryBlueLight)
                    .border(1.dp, PrimaryBlue, RoundedCornerShape(14.dp))
                    .clickable {
                        Toast
                            .makeText(
                                context,
                                "Product Image Selected / Updated",
                                Toast.LENGTH_SHORT
                            )
                            .show()
                    },
                contentAlignment = Alignment.Center
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Icon(
                        imageVector = Icons.Default.AddAPhoto,
                        contentDescription = "Upload Image",
                        tint = PrimaryBlue,
                        modifier = Modifier.size(32.dp)
                    )
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        text = "Tap to upload product image",
                        fontSize = 12.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = PrimaryBlue
                    )
                }
            }

            CustomTextField(
                value = name,
                onValueChange = { name = it },
                label = "Medicine Name",
                placeholder = "e.g. Paracetamol 650mg",
                leadingIcon = Icons.Default.Medication
            )

            CustomTextField(
                value = company,
                onValueChange = { company = it },
                label = "Company / Manufacturer",
                placeholder = "e.g. Cipla Ltd",
                leadingIcon = Icons.Default.Business
            )

            // Category Dropdown
            ExposedDropdownMenuBox(
                expanded = categoryExpanded,
                onExpandedChange = { categoryExpanded = !categoryExpanded }
            ) {
                CustomTextField(
                    value = category,
                    onValueChange = {},
                    label = "Category",
                    leadingIcon = Icons.Default.Category,
                    trailingIcon = {
                        ExposedDropdownMenuDefaults.TrailingIcon(expanded = categoryExpanded)
                    },
                    modifier = Modifier.menuAnchor()
                )

                ExposedDropdownMenu(
                    expanded = categoryExpanded,
                    onDismissRequest = { categoryExpanded = false },
                    modifier = Modifier.background(SurfaceWhite)
                ) {
                    categoryList.forEach { cat ->
                        DropdownMenuItem(
                            text = { Text(cat) },
                            onClick = {
                                category = cat
                                categoryExpanded = false
                            }
                        )
                    }
                }
            }

            CustomTextField(
                value = batchNumber,
                onValueChange = { batchNumber = it },
                label = "Batch Number",
                placeholder = "e.g. BAT-2026-88",
                leadingIcon = Icons.Default.QrCode
            )

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                CustomTextField(
                    value = purchasePriceStr,
                    onValueChange = { purchasePriceStr = it },
                    label = "Purchase Price (₹)",
                    placeholder = "45.0",
                    leadingIcon = Icons.Default.AttachMoney,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.weight(1f)
                )

                CustomTextField(
                    value = sellingPriceStr,
                    onValueChange = { sellingPriceStr = it },
                    label = "Selling Price (₹)",
                    placeholder = "75.0",
                    leadingIcon = Icons.Default.Sell,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.weight(1f)
                )
            }

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                CustomTextField(
                    value = quantityStr,
                    onValueChange = { quantityStr = it },
                    label = "Quantity",
                    placeholder = "100",
                    leadingIcon = Icons.Default.FormatListNumbered,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.weight(1f)
                )

                CustomTextField(
                    value = expiryDate,
                    onValueChange = { expiryDate = it },
                    label = "Expiry Date (YYYY-MM-DD)",
                    placeholder = "2028-05-31",
                    leadingIcon = Icons.Default.CalendarToday,
                    modifier = Modifier.weight(1f)
                )
            }

            // Distributor Selector Dropdown
            ExposedDropdownMenuBox(
                expanded = distributorExpanded,
                onExpandedChange = { distributorExpanded = !distributorExpanded }
            ) {
                CustomTextField(
                    value = selectedDistributor,
                    onValueChange = {},
                    label = "Primary Distributor",
                    leadingIcon = Icons.Default.LocalShipping,
                    trailingIcon = {
                        ExposedDropdownMenuDefaults.TrailingIcon(expanded = distributorExpanded)
                    },
                    modifier = Modifier.menuAnchor()
                )

                ExposedDropdownMenu(
                    expanded = distributorExpanded,
                    onDismissRequest = { distributorExpanded = false },
                    modifier = Modifier.background(SurfaceWhite)
                ) {
                    distributors.forEach { dist ->
                        DropdownMenuItem(
                            text = { Text(dist.name) },
                            onClick = {
                                selectedDistributor = dist.name
                                distributorExpanded = false
                            }
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                OutlinedButton(
                    onClick = onNavigateBack,
                    shape = RoundedCornerShape(14.dp),
                    modifier = Modifier
                        .weight(1f)
                        .height(52.dp)
                ) {
                    Text("Cancel", color = TextSecondary)
                }

                CustomButton(
                    text = if (existingMedicine == null) "Save Product" else "Update Product",
                    onClick = {
                        val purchasePrice = purchasePriceStr.toDoubleOrNull() ?: 0.0
                        val sellingPrice = sellingPriceStr.toDoubleOrNull() ?: 0.0
                        val quantity = quantityStr.toIntOrNull() ?: 0

                        if (name.isBlank() || company.isBlank()) {
                            Toast.makeText(context, "Please fill in product name and company", Toast.LENGTH_SHORT).show()
                            return@CustomButton
                        }

                        if (existingMedicine == null) {
                            val newMed = Medicine(
                                id = "M" + System.currentTimeMillis().toString().takeLast(4),
                                name = name,
                                company = company,
                                category = category,
                                batchNumber = batchNumber,
                                purchasePrice = purchasePrice,
                                sellingPrice = sellingPrice,
                                quantity = quantity,
                                expiryDate = expiryDate,
                                distributorName = selectedDistributor
                            )
                            viewModel.addMedicine(newMed)
                            Toast.makeText(context, "Medicine Saved Successfully!", Toast.LENGTH_SHORT).show()
                        } else {
                            val updatedMed = existingMedicine.copy(
                                name = name,
                                company = company,
                                category = category,
                                batchNumber = batchNumber,
                                purchasePrice = purchasePrice,
                                sellingPrice = sellingPrice,
                                quantity = quantity,
                                expiryDate = expiryDate,
                                distributorName = selectedDistributor
                            )
                            viewModel.updateMedicine(updatedMed)
                            Toast.makeText(context, "Medicine Updated Successfully!", Toast.LENGTH_SHORT).show()
                        }

                        onNavigateBack()
                    },
                    modifier = Modifier.weight(1f)
                )
            }
        }
    }
}
