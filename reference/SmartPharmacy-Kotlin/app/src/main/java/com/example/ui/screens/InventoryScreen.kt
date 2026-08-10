package com.example.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Warning
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.model.Medicine
import com.example.ui.components.CustomSearchBar
import com.example.ui.components.MedicineCard
import com.example.ui.theme.*
import com.example.ui.viewmodel.PharmacyViewModel

@Composable
fun InventoryScreen(
    viewModel: PharmacyViewModel,
    onNavigateToAddProduct: () -> Unit,
    onNavigateToProductDetails: (String) -> Unit
) {
    val medicines by viewModel.medicines.collectAsState()
    val searchQuery by viewModel.inventorySearch.collectAsState()

    var selectedCategory by remember { mutableStateOf("All") }

    val categories = remember(medicines) {
        listOf("All", "Low Stock", "Antibiotics", "Analgesics", "Cardiovascular", "Antidiabetic", "Gastrointestinal", "Vitamins & Supplements", "Respiratory", "Dermatology")
    }

    val filteredMedicines = remember(medicines, searchQuery, selectedCategory) {
        medicines.filter { med ->
            val matchesQuery = med.name.contains(searchQuery, ignoreCase = true) ||
                    med.company.contains(searchQuery, ignoreCase = true) ||
                    med.category.contains(searchQuery, ignoreCase = true)

            val matchesCategory = when (selectedCategory) {
                "All" -> true
                "Low Stock" -> med.quantity <= med.minStockThreshold
                else -> med.category.equals(selectedCategory, ignoreCase = true)
            }

            matchesQuery && matchesCategory
        }
    }

    Scaffold(
        floatingActionButton = {
            FloatingActionButton(
                onClick = onNavigateToAddProduct,
                containerColor = PrimaryBlue,
                contentColor = SurfaceWhite,
                shape = RoundedCornerShape(16.dp),
                modifier = Modifier.testTag("fab_add_product")
            ) {
                Row(
                    modifier = Modifier.padding(horizontal = 16.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(imageVector = Icons.Default.Add, contentDescription = "Add Product")
                    Spacer(modifier = Modifier.width(6.dp))
                    Text("Add Product", fontWeight = FontWeight.Bold)
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

            // Search Bar
            CustomSearchBar(
                query = searchQuery,
                onQueryChange = { viewModel.setInventorySearch(it) },
                placeholder = "Search 50+ medicines, brand..."
            )

            Spacer(modifier = Modifier.height(10.dp))

            // Category Filter Chips
            LazyRow(
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                modifier = Modifier.fillMaxWidth()
            ) {
                items(categories) { category ->
                    val isSelected = selectedCategory == category
                    FilterChip(
                        selected = isSelected,
                        onClick = { selectedCategory = category },
                        label = {
                            Text(
                                text = category,
                                fontSize = 12.sp,
                                fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium
                            )
                        },
                        shape = RoundedCornerShape(20.dp),
                        colors = FilterChipDefaults.filterChipColors(
                            selectedContainerColor = PrimaryBlue,
                            selectedLabelColor = SurfaceWhite,
                            containerColor = SurfaceCard,
                            labelColor = TextSecondary
                        )
                    )
                }
            }

            Spacer(modifier = Modifier.height(12.dp))

            Text(
                text = "Showing ${filteredMedicines.size} Medicines",
                fontSize = 13.sp,
                fontWeight = FontWeight.Medium,
                color = TextSecondary
            )

            Spacer(modifier = Modifier.height(8.dp))

            if (filteredMedicines.isEmpty()) {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .weight(1f),
                    contentAlignment = Alignment.Center
                ) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Icon(
                            imageVector = Icons.Default.Warning,
                            contentDescription = null,
                            tint = TextMuted,
                            modifier = Modifier.size(48.dp)
                        )
                        Spacer(modifier = Modifier.height(12.dp))
                        Text(
                            text = "No medicines found",
                            fontSize = 16.sp,
                            fontWeight = FontWeight.Bold,
                            color = TextPrimary
                        )
                        Text(
                            text = "Try adjusting your search or category filter",
                            fontSize = 13.sp,
                            color = TextSecondary
                        )
                    }
                }
            } else {
                LazyColumn(
                    verticalArrangement = Arrangement.spacedBy(10.dp),
                    contentPadding = PaddingValues(bottom = 80.dp),
                    modifier = Modifier.weight(1f)
                ) {
                    items(filteredMedicines, key = { it.id }) { medicine ->
                        MedicineCard(
                            medicine = medicine,
                            isExpired = viewModel.isExpired(medicine.expiryDate),
                            isExpiringSoon = viewModel.isExpiringIn30Days(medicine.expiryDate),
                            onClick = { onNavigateToProductDetails(medicine.id) }
                        )
                    }
                }
            }
        }
    }
}
