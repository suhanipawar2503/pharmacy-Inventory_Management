package com.example.ui.navigation

import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Assessment
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Inventory2
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.PointOfSale
import androidx.compose.material.icons.outlined.Assessment
import androidx.compose.material.icons.outlined.Home
import androidx.compose.material.icons.outlined.Inventory2
import androidx.compose.material.icons.outlined.Person
import androidx.compose.material.icons.outlined.PointOfSale
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.example.ui.screens.*
import com.example.ui.theme.PrimaryBlue
import com.example.ui.theme.SurfaceWhite
import com.example.ui.theme.TextMuted
import com.example.ui.theme.TextPrimary
import com.example.ui.viewmodel.PharmacyViewModel

sealed class Screen(val route: String) {
    object Splash : Screen("splash")
    object Login : Screen("login")
    object MainContainer : Screen("main_container")
    object AddProduct : Screen("add_product")
    object EditProduct : Screen("edit_product/{medicineId}") {
        fun createRoute(id: String) = "edit_product/$id"
    }
    object ProductDetails : Screen("product_details/{medicineId}") {
        fun createRoute(id: String) = "product_details/$id"
    }
    object AddPurchase : Screen("add_purchase")
    object PurchaseDetails : Screen("purchase_details/{purchaseId}") {
        fun createRoute(id: String) = "purchase_details/$id"
    }
    object AddDistributor : Screen("add_distributor")
    object DistributorDetails : Screen("distributor_details/{distributorId}") {
        fun createRoute(id: String) = "distributor_details/$id"
    }
    object CreateBill : Screen("create_bill")
    object Invoice : Screen("invoice/{saleId}") {
        fun createRoute(id: String) = "invoice/$id"
    }
    object Expiry : Screen("expiry")
    object OcrScan : Screen("ocr_scan")
}

enum class BottomTab(
    val title: String,
    val selectedIcon: ImageVector,
    val unselectedIcon: ImageVector,
    val route: String
) {
    HOME("Home", Icons.Filled.Home, Icons.Outlined.Home, "tab_home"),
    INVENTORY("Inventory", Icons.Filled.Inventory2, Icons.Outlined.Inventory2, "tab_inventory"),
    SALES("Sales", Icons.Filled.PointOfSale, Icons.Outlined.PointOfSale, "tab_sales"),
    REPORTS("Reports", Icons.Filled.Assessment, Icons.Outlined.Assessment, "tab_reports"),
    PROFILE("Profile", Icons.Filled.Person, Icons.Outlined.Person, "tab_profile")
}

@Composable
fun MainAppNavigation() {
    val navController = rememberNavController()
    val viewModel: PharmacyViewModel = viewModel()

    NavHost(
        navController = navController,
        startDestination = Screen.Splash.route
    ) {
        composable(Screen.Splash.route) {
            SplashScreen(
                onSplashFinished = {
                    navController.navigate(Screen.Login.route) {
                        popUpTo(Screen.Splash.route) { inclusive = true }
                    }
                }
            )
        }

        composable(Screen.Login.route) {
            LoginScreen(
                onLoginSuccess = { email ->
                    viewModel.login(email)
                    navController.navigate(Screen.MainContainer.route) {
                        popUpTo(Screen.Login.route) { inclusive = true }
                    }
                }
            )
        }

        composable(Screen.MainContainer.route) {
            MainContainerScreen(
                viewModel = viewModel,
                onNavigateToAddProduct = { navController.navigate(Screen.AddProduct.route) },
                onNavigateToProductDetails = { id -> navController.navigate(Screen.ProductDetails.createRoute(id)) },
                onNavigateToNewSale = { navController.navigate(Screen.CreateBill.route) },
                onNavigateToNewPurchase = { navController.navigate(Screen.AddPurchase.route) },
                onNavigateToPurchaseDetails = { id -> navController.navigate(Screen.PurchaseDetails.createRoute(id)) },
                onNavigateToAddDistributor = { navController.navigate(Screen.AddDistributor.route) },
                onNavigateToDistributorDetails = { id -> navController.navigate(Screen.DistributorDetails.createRoute(id)) },
                onNavigateToOcrScan = { navController.navigate(Screen.OcrScan.route) },
                onNavigateToExpiry = { navController.navigate(Screen.Expiry.route) },
                onNavigateToInvoice = { id -> navController.navigate(Screen.Invoice.createRoute(id)) },
                onLogout = {
                    navController.navigate(Screen.Login.route) {
                        popUpTo(Screen.MainContainer.route) { inclusive = true }
                    }
                }
            )
        }

        composable(Screen.AddProduct.route) {
            AddEditProductScreen(
                viewModel = viewModel,
                onNavigateBack = { navController.popBackStack() }
            )
        }

        composable(
            route = Screen.EditProduct.route,
            arguments = listOf(navArgument("medicineId") { type = NavType.StringType })
        ) { backStackEntry ->
            val medicineId = backStackEntry.arguments?.getString("medicineId")
            AddEditProductScreen(
                viewModel = viewModel,
                medicineIdToEdit = medicineId,
                onNavigateBack = { navController.popBackStack() }
            )
        }

        composable(
            route = Screen.ProductDetails.route,
            arguments = listOf(navArgument("medicineId") { type = NavType.StringType })
        ) { backStackEntry ->
            val medicineId = backStackEntry.arguments?.getString("medicineId") ?: ""
            ProductDetailsScreen(
                viewModel = viewModel,
                medicineId = medicineId,
                onNavigateToEdit = { id -> navController.navigate(Screen.EditProduct.createRoute(id)) },
                onNavigateBack = { navController.popBackStack() }
            )
        }

        composable(Screen.AddPurchase.route) {
            AddPurchaseScreen(
                viewModel = viewModel,
                onNavigateBack = { navController.popBackStack() }
            )
        }

        composable(
            route = Screen.PurchaseDetails.route,
            arguments = listOf(navArgument("purchaseId") { type = NavType.StringType })
        ) { backStackEntry ->
            val purchaseId = backStackEntry.arguments?.getString("purchaseId") ?: ""
            PurchaseDetailsScreen(
                viewModel = viewModel,
                purchaseId = purchaseId,
                onNavigateBack = { navController.popBackStack() }
            )
        }

        composable(Screen.AddDistributor.route) {
            AddDistributorScreen(
                viewModel = viewModel,
                onNavigateBack = { navController.popBackStack() }
            )
        }

        composable(
            route = Screen.DistributorDetails.route,
            arguments = listOf(navArgument("distributorId") { type = NavType.StringType })
        ) { backStackEntry ->
            val distId = backStackEntry.arguments?.getString("distributorId") ?: ""
            DistributorDetailsScreen(
                viewModel = viewModel,
                distributorId = distId,
                onNavigateBack = { navController.popBackStack() }
            )
        }

        composable(Screen.CreateBill.route) {
            CreateBillScreen(
                viewModel = viewModel,
                onNavigateToGeneratedInvoice = { id ->
                    navController.popBackStack()
                    navController.navigate(Screen.Invoice.createRoute(id))
                },
                onNavigateBack = { navController.popBackStack() }
            )
        }

        composable(
            route = Screen.Invoice.route,
            arguments = listOf(navArgument("saleId") { type = NavType.StringType })
        ) { backStackEntry ->
            val saleId = backStackEntry.arguments?.getString("saleId") ?: ""
            InvoiceScreen(
                viewModel = viewModel,
                saleId = saleId,
                onNavigateBack = { navController.popBackStack() }
            )
        }

        composable(Screen.Expiry.route) {
            ExpiryScreen(
                viewModel = viewModel,
                onNavigateToProductDetails = { id -> navController.navigate(Screen.ProductDetails.createRoute(id)) },
                onNavigateBack = { navController.popBackStack() }
            )
        }

        composable(Screen.OcrScan.route) {
            OcrBillScanScreen(
                viewModel = viewModel,
                onNavigateBack = { navController.popBackStack() }
            )
        }
    }
}

@Composable
fun MainContainerScreen(
    viewModel: PharmacyViewModel,
    onNavigateToAddProduct: () -> Unit,
    onNavigateToProductDetails: (String) -> Unit,
    onNavigateToNewSale: () -> Unit,
    onNavigateToNewPurchase: () -> Unit,
    onNavigateToPurchaseDetails: (String) -> Unit,
    onNavigateToAddDistributor: () -> Unit,
    onNavigateToDistributorDetails: (String) -> Unit,
    onNavigateToOcrScan: () -> Unit,
    onNavigateToExpiry: () -> Unit,
    onNavigateToInvoice: (String) -> Unit,
    onLogout: () -> Unit
) {
    var selectedTab by remember { mutableStateOf(BottomTab.HOME) }

    Scaffold(
        bottomBar = {
            NavigationBar(
                containerColor = SurfaceWhite,
                tonalElevation = 8.dp,
                modifier = Modifier.testTag("bottom_navigation_bar")
            ) {
                BottomTab.values().forEach { tab ->
                    val isSelected = selectedTab == tab
                    NavigationBarItem(
                        selected = isSelected,
                        onClick = { selectedTab = tab },
                        icon = {
                            Icon(
                                imageVector = if (isSelected) tab.selectedIcon else tab.unselectedIcon,
                                contentDescription = tab.title
                            )
                        },
                        label = {
                            Text(
                                text = tab.title,
                                fontSize = 11.sp,
                                fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Normal
                            )
                        },
                        colors = NavigationBarItemDefaults.colors(
                            selectedIconColor = PrimaryBlue,
                            selectedTextColor = PrimaryBlue,
                            indicatorColor = PrimaryBlue.copy(alpha = 0.15f),
                            unselectedIconColor = TextMuted,
                            unselectedTextColor = TextMuted
                        )
                    )
                }
            }
        },
        containerColor = SurfaceWhite
    ) { innerPadding ->
        Surface(
            modifier = Modifier
                .padding(innerPadding)
        ) {
            when (selectedTab) {
                BottomTab.HOME -> DashboardScreen(
                    viewModel = viewModel,
                    onNavigateToAddProduct = onNavigateToAddProduct,
                    onNavigateToNewSale = onNavigateToNewSale,
                    onNavigateToNewPurchase = onNavigateToNewPurchase,
                    onNavigateToOcrScan = onNavigateToOcrScan,
                    onNavigateToExpiry = onNavigateToExpiry,
                    onNavigateToInventory = { selectedTab = BottomTab.INVENTORY },
                    onNavigateToSales = { selectedTab = BottomTab.SALES }
                )

                BottomTab.INVENTORY -> InventoryScreen(
                    viewModel = viewModel,
                    onNavigateToAddProduct = onNavigateToAddProduct,
                    onNavigateToProductDetails = onNavigateToProductDetails
                )

                BottomTab.SALES -> SalesListScreen(
                    viewModel = viewModel,
                    onNavigateToCreateBill = onNavigateToNewSale,
                    onNavigateToInvoice = onNavigateToInvoice
                )

                BottomTab.REPORTS -> ReportsScreen(
                    viewModel = viewModel
                )

                BottomTab.PROFILE -> ProfileScreen(
                    viewModel = viewModel,
                    onLogout = onLogout
                )
            }
        }
    }
}
