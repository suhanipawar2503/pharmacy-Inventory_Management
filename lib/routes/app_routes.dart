import 'package:flutter/material.dart';
import '../screens/main_container.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/product_details_screen.dart';
import '../screens/add_edit_product_screen.dart';
import '../screens/distributor_screens.dart';
import '../screens/purchase_screens.dart';
import '../screens/sales_screens.dart';
import '../screens/expiry_screen.dart';
import '../screens/ocr_bill_scan_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String mainContainer = '/main_container';
  static const String addProduct = '/add_product';
  static const String editProduct = '/edit_product';
  static const String productDetails = '/product_details';
  static const String addPurchase = '/add_purchase';
  static const String purchaseDetails = '/purchase_details';
  static const String addDistributor = '/add_distributor';
  static const String distributorDetails = '/distributor_details';
  static const String distributorList = '/distributor_list';
  static const String purchaseList = '/purchase_list';
  static const String createBill = '/create_bill';
  static const String invoice = '/invoice';
  static const String expiry = '/expiry';
  static const String ocrScan = '/ocr_scan';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case mainContainer:
        return MaterialPageRoute(builder: (_) => const MainContainer());
      case addProduct:
        return MaterialPageRoute(builder: (_) => const AddEditProductScreen());
      case editProduct:
        final id = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => AddEditProductScreen(medicineIdToEdit: id),
        );
      case productDetails:
        final id = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(medicineId: id),
        );
      case addPurchase:
        return MaterialPageRoute(builder: (_) => const AddPurchaseScreen());
      case purchaseDetails:
        final id = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => PurchaseDetailsScreen(purchaseId: id),
        );
      case purchaseList:
        return MaterialPageRoute(builder: (_) => const PurchaseListScreen());
      case addDistributor:
        return MaterialPageRoute(
          builder: (_) => const AddDistributorScreen(),
        );
      case distributorDetails:
        final id = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => DistributorDetailsScreen(distributorId: id),
        );
      case distributorList:
        return MaterialPageRoute(
          builder: (_) => const DistributorListScreen(),
        );
      case createBill:
        return MaterialPageRoute(
          builder: (_) => const CreateBillScreen(),
        );
      case invoice:
        final id = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => InvoiceScreen(saleId: id),
        );
      case expiry:
        return MaterialPageRoute(
          builder: (_) => const ExpiryScreen(),
        );
      case ocrScan:
        return MaterialPageRoute(
          builder: (_) => const OcrBillScanScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
