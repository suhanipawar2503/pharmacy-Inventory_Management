import 'package:flutter_test/flutter_test.dart';
import 'package:smart_pharmacy_flutter/main.dart';

void main() {
  testWidgets('App loads and displays splash screen smoke test',
          (WidgetTester tester) async {
        await tester.pumpWidget(const SmartPharmacyApp());

        expect(find.text('Smart Pharmacy'), findsWidgets);

        await tester.pump(const Duration(seconds: 2));
      });
}