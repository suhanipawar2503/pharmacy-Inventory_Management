import 'package:flutter/material.dart';
import '../screens/main_container.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/product_details_screen.dart';
import '../screens/add_edit_product_screen.dart';
import '../widgets/common/placeholder_screen.dart';

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
            builder: (_) => AddEditProductScreen(medicineIdToEdit: id));
      case productDetails:
        final id = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(medicineId: id));
      case addPurchase:
        return MaterialPageRoute(
            builder: (_) => const PlaceholderScreen(title: "Add Purchase"));
      case purchaseDetails:
        final id = settings.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => PlaceholderScreen(title: "Purchase Details: $id"));
      case addDistributor:
        return MaterialPageRoute(
            builder: (_) => const PlaceholderScreen(title: "Add Distributor"));
      case distributorDetails:
        final id = settings.arguments as String?;
        return MaterialPageRoute(
            builder: (_) =>
                PlaceholderScreen(title: "Distributor Details: $id"));
      case createBill:
        return MaterialPageRoute(
            builder: (_) => const PlaceholderScreen(title: "Create Bill"));
      case invoice:
        final id = settings.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => PlaceholderScreen(title: "Invoice: $id"));
      case expiry:
        return MaterialPageRoute(
            builder: (_) => const PlaceholderScreen(title: "Expiry Management"));
      case ocrScan:
        return MaterialPageRoute(
            builder: (_) => const PlaceholderScreen(title: "OCR Bill Scan"));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
