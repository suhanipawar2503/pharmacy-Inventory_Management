package com.example.ui.screens

import android.content.Intent
import android.net.Uri
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
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.outlined.Call
import androidx.compose.material.icons.outlined.Email
import androidx.compose.material.icons.outlined.LocationOn
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.model.Distributor
import com.example.ui.components.CustomButton
import com.example.ui.components.CustomSearchBar
import com.example.ui.components.CustomTextField
import com.example.ui.components.DistributorCard
import com.example.ui.theme.*
import com.example.ui.viewmodel.PharmacyViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DistributorListScreen(
    viewModel: PharmacyViewModel,
    onNavigateToAddDistributor: () -> Unit,
    onNavigateToDistributorDetails: (String) -> Unit
) {
    val distributors by viewModel.distributors.collectAsState()
    val searchQuery by viewModel.distributorSearch.collectAsState()

    val filtered = remember(distributors, searchQuery) {
        distributors.filter {
            it.name.contains(searchQuery, ignoreCase = true) ||
                    it.phone.contains(searchQuery, ignoreCase = true) ||
                    it.address.contains(searchQuery, ignoreCase = true)
        }
    }

    Scaffold(
        floatingActionButton = {
            FloatingActionButton(
                onClick = onNavigateToAddDistributor,
                containerColor = SecondaryTeal,
                contentColor = SurfaceWhite,
                shape = RoundedCornerShape(16.dp),
                modifier = Modifier.testTag("fab_add_distributor")
            ) {
                Row(
                    modifier = Modifier.padding(horizontal = 16.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(imageVector = Icons.Default.Add, contentDescription = "Add Distributor")
                    Spacer(modifier = Modifier.width(6.dp))
                    Text("Add Distributor", fontWeight = FontWeight.Bold)
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
                onQueryChange = { viewModel.setDistributorSearch(it) },
                placeholder = "Search 15+ distributors, phone, city..."
            )

            Spacer(modifier = Modifier.height(12.dp))

            Text(
                text = "Registered Distributors (${filtered.size})",
                fontSize = 14.sp,
                fontWeight = FontWeight.Bold,
                color = TextPrimary
            )

            Spacer(modifier = Modifier.height(8.dp))

            LazyColumn(
                verticalArrangement = Arrangement.spacedBy(10.dp),
                contentPadding = PaddingValues(bottom = 80.dp)
            ) {
                items(filtered, key = { it.id }) { dist ->
                    DistributorCard(
                        distributor = dist,
                        onClick = { onNavigateToDistributorDetails(dist.id) }
                    )
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddDistributorScreen(
    viewModel: PharmacyViewModel,
    onNavigateBack: () -> Unit
) {
    val context = LocalContext.current

    var name by remember { mutableStateOf("") }
    var phone by remember { mutableStateOf("") }
    var address by remember { mutableStateOf("") }
    var gstNumber by remember { mutableStateOf("") }
    var email by remember { mutableStateOf("") }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Add Distributor", fontWeight = FontWeight.Bold) },
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
                value = name,
                onValueChange = { name = it },
                label = "Distributor / Firm Name",
                placeholder = "e.g. Apex Pharma Wholesale",
                leadingIcon = Icons.Default.LocalShipping
            )

            CustomTextField(
                value = phone,
                onValueChange = { phone = it },
                label = "Phone Number",
                placeholder = "+91 98000 12345",
                leadingIcon = Icons.Default.Phone
            )

            CustomTextField(
                value = email,
                onValueChange = { email = it },
                label = "Email Address (Optional)",
                placeholder = "orders@distributor.com",
                leadingIcon = Icons.Default.Email
            )

            CustomTextField(
                value = address,
                onValueChange = { address = it },
                label = "Office / Warehouse Address",
                placeholder = "Street, Area, City",
                leadingIcon = Icons.Default.LocationOn,
                singleLine = false
            )

            CustomTextField(
                value = gstNumber,
                onValueChange = { gstNumber = it },
                label = "GST Number (Optional)",
                placeholder = "e.g. 27AAAAA0000A1Z5",
                leadingIcon = Icons.Default.Receipt
            )

            Spacer(modifier = Modifier.height(16.dp))

            CustomButton(
                text = "Save Distributor",
                containerColor = SecondaryTeal,
                onClick = {
                    if (name.isBlank() || phone.isBlank()) {
                        Toast.makeText(context, "Please enter name and phone number", Toast.LENGTH_SHORT).show()
                        return@CustomButton
                    }

                    val newDist = Distributor(
                        id = "D" + System.currentTimeMillis().toString().takeLast(4),
                        name = name,
                        phone = phone,
                        address = address.ifBlank { "Commercial Hub" },
                        gstNumber = gstNumber,
                        email = email.ifBlank { "info@$name.com" }
                    )

                    viewModel.addDistributor(newDist)
                    Toast.makeText(context, "Distributor Saved Successfully!", Toast.LENGTH_SHORT).show()
                    onNavigateBack()
                }
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DistributorDetailsScreen(
    viewModel: PharmacyViewModel,
    distributorId: String,
    onNavigateBack: () -> Unit
) {
    val context = LocalContext.current
    val distributors by viewModel.distributors.collectAsState()
    val medicines by viewModel.medicines.collectAsState()

    val distributor = distributors.find { it.id == distributorId }

    if (distributor == null) {
        Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            Text("Distributor not found")
        }
        return
    }

    val suppliedMedicines = remember(distributor, medicines) {
        medicines.filter { it.distributorName.equals(distributor.name, ignoreCase = true) }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Distributor Profile", fontWeight = FontWeight.Bold) },
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
            // Distributor Header Card
            Card(
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = SecondaryTealLight),
                modifier = Modifier.fillMaxWidth()
            ) {
                Column(modifier = Modifier.padding(20.dp)) {
                    Text(text = distributor.name, fontSize = 20.sp, fontWeight = FontWeight.Bold, color = SecondaryTeal)
                    Spacer(modifier = Modifier.height(8.dp))

                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(imageVector = Icons.Outlined.Call, contentDescription = null, tint = SecondaryTeal, modifier = Modifier.size(18.dp))
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(text = distributor.phone, fontSize = 14.sp, fontWeight = FontWeight.SemiBold, color = TextPrimary)
                    }

                    Spacer(modifier = Modifier.height(4.dp))

                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(imageVector = Icons.Outlined.Email, contentDescription = null, tint = SecondaryTeal, modifier = Modifier.size(18.dp))
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(text = distributor.email, fontSize = 13.sp, color = TextSecondary)
                    }

                    Spacer(modifier = Modifier.height(4.dp))

                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(imageVector = Icons.Outlined.LocationOn, contentDescription = null, tint = SecondaryTeal, modifier = Modifier.size(18.dp))
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(text = distributor.address, fontSize = 13.sp, color = TextSecondary)
                    }

                    if (distributor.gstNumber.isNotEmpty()) {
                        Spacer(modifier = Modifier.height(8.dp))
                        Surface(shape = RoundedCornerShape(8.dp), color = SurfaceWhite) {
                            Text(
                                text = "GSTIN: ${distributor.gstNumber}",
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Bold,
                                color = SecondaryTeal,
                                modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
                            )
                        }
                    }
                }
            }

            // Quick Call / Mail Actions
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                Button(
                    onClick = {
                        val intent = Intent(Intent.ACTION_DIAL, Uri.parse("tel:${distributor.phone}"))
                        context.startActivity(intent)
                    },
                    colors = ButtonDefaults.buttonColors(containerColor = SecondaryTeal),
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier
                        .weight(1f)
                        .height(46.dp)
                ) {
                    Icon(imageVector = Icons.Default.Call, contentDescription = null, modifier = Modifier.size(18.dp))
                    Spacer(modifier = Modifier.width(6.dp))
                    Text("Call Supplier")
                }

                OutlinedButton(
                    onClick = {
                        Toast.makeText(context, "Opening mail client for ${distributor.email}", Toast.LENGTH_SHORT).show()
                    },
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier
                        .weight(1f)
                        .height(46.dp)
                ) {
                    Icon(imageVector = Icons.Default.Email, contentDescription = null, modifier = Modifier.size(18.dp))
                    Spacer(modifier = Modifier.width(6.dp))
                    Text("Email")
                }
            }

            // Supplied Medicines Section
            Text(
                text = "Supplied Medicines (${suppliedMedicines.size})",
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = TextPrimary
            )

            if (suppliedMedicines.isEmpty()) {
                Text(
                    text = "No medicines associated with this distributor yet.",
                    fontSize = 13.sp,
                    color = TextSecondary
                )
            } else {
                Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    suppliedMedicines.forEach { med ->
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
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Column {
                                    Text(text = med.name, fontSize = 14.sp, fontWeight = FontWeight.Bold, color = TextPrimary)
                                    Text(text = "Batch: ${med.batchNumber} • ${med.company}", fontSize = 12.sp, color = TextSecondary)
                                }
                                Text(text = "${med.quantity} in stock", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = PrimaryBlue)
                            }
                        }
                    }
                }
            }
        }
    }
}
