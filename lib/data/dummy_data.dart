import 'dart:math';
import '../models/medicine.dart';
import '../models/distributor.dart';
import '../models/purchase_record.dart';
import '../models/sale_item.dart';
import '../models/sale_record.dart';

class DummyData {
  static final List<Distributor> initialDistributors = [
    Distributor(id: "D01", name: "MedLife Wholesale Traders", phone: "+91 98230 11223", address: "Plot 42, Pharma Zone, Industrial Area, Mumbai", gstNumber: "27AAAAA0000A1Z5", email: "orders@medlifewholesale.com"),
    Distributor(id: "D02", name: "Apex Health Pharma Distributors", phone: "+91 98450 33445", address: "102 Central Avenue, Connaught Place, New Delhi", gstNumber: "07BBBCA1111B2Z4", email: "supply@apexpharma.in"),
    Distributor(id: "D03", name: "Sunshine Medical Agencies", phone: "+91 97110 55667", address: "Sector 18, Commercial Hub, Gurugram", gstNumber: "06CCCDE2222C3Z3", email: "contact@sunshinemedical.com"),
    Distributor(id: "D04", name: "CareMed Pharma Supplies", phone: "+91 99880 77889", address: "88 Ring Road, Near General Hospital, Ahmedabad", gstNumber: "24DDDDF3333D4Z2", email: "caremed.ahd@gmail.com"),
    Distributor(id: "D05", name: "Global Bio-Health Logistics", phone: "+91 94220 99001", address: "Building C, Trade Center, Bengaluru", gstNumber: "29EEEEG4444E5Z1", email: "sales@globalbiohealth.org"),
    Distributor(id: "D06", name: "Titan Healthcare Distributors", phone: "+91 98900 12345", address: "15 Market Yard, Pune", gstNumber: "27FFFFH5555F6Z0", email: "orders@titanhealth.com"),
    Distributor(id: "D07", name: "Vanguard Lifesciences", phone: "+91 91234 56789", address: "5th Cross, Malleshwaram, Bengaluru", gstNumber: "29GGGGJ6666G7Z9", email: "info@vanguardlife.in"),
    Distributor(id: "D08", name: "Reliance Pharma Stockists", phone: "+91 93456 78901", address: "GIDC Estate, Vadodara", gstNumber: "24HHHHK7777H8Z8", email: "sales@reliancepharma.com"),
    Distributor(id: "D09", name: "CityMed Agencies", phone: "+91 94567 89012", address: "MG Road, Zone 2, Bhopal", gstNumber: "23JJJJL8888J9Z7", email: "citymed.bhopal@yahoo.com"),
    Distributor(id: "D10", name: "Matrix Lifecare Depot", phone: "+91 95678 90123", address: "Station Road, Jaipur", gstNumber: "08KKKKM9999K0Z6", email: "support@matrixlifecare.com"),
    Distributor(id: "D11", name: "Zenith Medical Corp", phone: "+91 96789 01234", address: "Park Street, Kolkata", gstNumber: "19LLLLN1010L1Z5", email: "zenith.med@gmail.com"),
    Distributor(id: "D12", name: "Horizon Pharma Traders", phone: "+91 97890 12345", address: "Banjara Hills, Hyderabad", gstNumber: "36MMMMO2020M2Z4", email: "horizonpharma@hyderabad.com"),
    Distributor(id: "D13", name: "Sovereign Health Supplies", phone: "+91 98901 23456", address: "Anna Salai, Chennai", gstNumber: "33NNNNP3030N3Z3", email: "orders@sovereignhealth.in"),
    Distributor(id: "D14", name: "Unicorn Pharma Logistics", phone: "+91 99012 34567", address: "GS Road, Guwahati", gstNumber: "18PPPPR4040P4Z2", email: "guwahati@unicornpharma.com"),
    Distributor(id: "D15", name: "Everest Medical Wholesale", phone: "+91 90123 45678", address: "Mall Road, Chandigarh", gstNumber: "04QQQQT5050Q5Z1", email: "everest.pharma@gmail.com"),
  ];

  static final List<Medicine> initialMedicines = [
    Medicine(id: "M01", name: "Amoxicillin 500mg", company: "Cipla Ltd", category: "Antibiotics", batchNumber: "BAT-2024-01", purchasePrice: 35.0, sellingPrice: 52.0, quantity: 150, minStockThreshold: 20, expiryDate: "2027-08-15", distributorName: "MedLife Wholesale Traders"),
    Medicine(id: "M02", name: "Paracetamol 650mg (Dolo)", company: "Micro Labs", category: "Analgesics", batchNumber: "BAT-2024-02", purchasePrice: 12.0, sellingPrice: 28.0, quantity: 320, minStockThreshold: 50, expiryDate: "2028-01-20", distributorName: "Apex Health Pharma Distributors"),
    Medicine(id: "M03", name: "Azithromycin 500mg", company: "Zydus Cadila", category: "Antibiotics", batchNumber: "BAT-2023-99", purchasePrice: 60.0, sellingPrice: 115.0, quantity: 12, minStockThreshold: 25, expiryDate: "2026-08-10", distributorName: "MedLife Wholesale Traders"),
    Medicine(id: "M04", name: "Metformin 500mg", company: "Sun Pharma", category: "Antidiabetic", batchNumber: "BAT-2023-88", purchasePrice: 18.0, sellingPrice: 32.0, quantity: 8, minStockThreshold: 30, expiryDate: "2026-08-02", distributorName: "Sunshine Medical Agencies"),
    Medicine(id: "M05", name: "Pantoprazole 40mg (Pan-40)", company: "Alkem Labs", category: "Gastrointestinal", batchNumber: "BAT-2024-05", purchasePrice: 45.0, sellingPrice: 78.0, quantity: 210, minStockThreshold: 40, expiryDate: "2027-11-30", distributorName: "CareMed Pharma Supplies"),
    Medicine(id: "M06", name: "Atorvastatin 10mg", company: "Lupin Pharma", category: "Cardiovascular", batchNumber: "BAT-2024-06", purchasePrice: 52.0, sellingPrice: 95.0, quantity: 90, minStockThreshold: 20, expiryDate: "2027-05-18", distributorName: "Global Bio-Health Logistics"),
    Medicine(id: "M07", name: "Cetirizine 10mg (Okacet)", company: "Cipla Ltd", category: "Antihistamine", batchNumber: "BAT-2023-45", purchasePrice: 8.0, sellingPrice: 18.0, quantity: 0, minStockThreshold: 30, expiryDate: "2026-05-10", distributorName: "Titan Healthcare Distributors"),
    Medicine(id: "M08", name: "Ciprofloxacin 500mg", company: "Dr. Reddy's", category: "Antibiotics", batchNumber: "BAT-2023-12", purchasePrice: 28.0, sellingPrice: 48.0, quantity: 5, minStockThreshold: 20, expiryDate: "2026-08-18", distributorName: "Vanguard Lifesciences"),
    Medicine(id: "M09", name: "Telmisartan 40mg", company: "Torrent Pharma", category: "Cardiovascular", batchNumber: "BAT-2024-09", purchasePrice: 40.0, sellingPrice: 72.0, quantity: 180, minStockThreshold: 30, expiryDate: "2027-10-12", distributorName: "Reliance Pharma Stockists"),
    Medicine(id: "M10", name: "Vitamin C + Zinc (Celin)", company: "Abbott India", category: "Vitamins & Supplements", batchNumber: "BAT-2024-10", purchasePrice: 15.0, sellingPrice: 35.0, quantity: 450, minStockThreshold: 60, expiryDate: "2028-03-25", distributorName: "CityMed Agencies"),
    Medicine(id: "M11", name: "Ibuprofen 400mg (Brufen)", company: "Abbott India", category: "Analgesics", batchNumber: "BAT-2023-01", purchasePrice: 10.0, sellingPrice: 22.0, quantity: 3, minStockThreshold: 25, expiryDate: "2026-04-12", distributorName: "Matrix Lifecare Depot"),
    Medicine(id: "M12", name: "Montelukast + Levocetirizine", company: "Mankind Pharma", category: "Respiratory", batchNumber: "BAT-2024-12", purchasePrice: 65.0, sellingPrice: 110.0, quantity: 85, minStockThreshold: 20, expiryDate: "2027-09-08", distributorName: "Zenith Medical Corp"),
    Medicine(id: "M13", name: "Omeprazole 20mg", company: "Torrent Pharma", category: "Gastrointestinal", batchNumber: "BAT-2024-13", purchasePrice: 22.0, sellingPrice: 42.0, quantity: 140, minStockThreshold: 30, expiryDate: "2027-12-01", distributorName: "Horizon Pharma Traders"),
    Medicine(id: "M14", name: "Losartan Potassium 50mg", company: "Sun Pharma", category: "Cardiovascular", batchNumber: "BAT-2024-14", purchasePrice: 38.0, sellingPrice: 68.0, quantity: 95, minStockThreshold: 20, expiryDate: "2027-07-22", distributorName: "Sovereign Health Supplies"),
    Medicine(id: "M15", name: "Amlodipine 5mg", company: "Pfizer Ltd", category: "Cardiovascular", batchNumber: "BAT-2024-15", purchasePrice: 14.0, sellingPrice: 28.0, quantity: 260, minStockThreshold: 40, expiryDate: "2028-02-14", distributorName: "Unicorn Pharma Logistics"),
    Medicine(id: "M16", name: "Calcium + Vitamin D3 (Shelcal)", company: "Torrent Pharma", category: "Vitamins & Supplements", batchNumber: "BAT-2024-16", purchasePrice: 72.0, sellingPrice: 130.0, quantity: 110, minStockThreshold: 25, expiryDate: "2027-06-30", distributorName: "Everest Medical Wholesale"),
    Medicine(id: "M17", name: "Amoxicillin + Clavulanic Acid (Augmentin 625)", company: "GlaxoSmithKline", category: "Antibiotics", batchNumber: "BAT-2024-17", purchasePrice: 110.0, sellingPrice: 185.0, quantity: 70, minStockThreshold: 15, expiryDate: "2026-08-22", distributorName: "MedLife Wholesale Traders"),
    Medicine(id: "M18", name: "Ranitidine 150mg (Aciloc)", company: "Cadila Healthcare", category: "Gastrointestinal", batchNumber: "BAT-2023-02", purchasePrice: 9.0, sellingPrice: 18.0, quantity: 15, minStockThreshold: 20, expiryDate: "2026-03-20", distributorName: "Apex Health Pharma Distributors"),
    Medicine(id: "M19", name: "Diclofenac Sodium 50mg (Voveran)", company: "Novartis", category: "Analgesics", batchNumber: "BAT-2024-19", purchasePrice: 25.0, sellingPrice: 46.0, quantity: 130, minStockThreshold: 25, expiryDate: "2027-04-11", distributorName: "Sunshine Medical Agencies"),
    Medicine(id: "M20", name: "Levothyroxine 50mcg (Thyronorm)", company: "Abbott India", category: "Endocrinology", batchNumber: "BAT-2024-20", purchasePrice: 80.0, sellingPrice: 145.0, quantity: 175, minStockThreshold: 30, expiryDate: "2027-11-15", distributorName: "CareMed Pharma Supplies"),
    Medicine(id: "M21", name: "Glimepiride 2mg", company: "Sanofi India", category: "Antidiabetic", batchNumber: "BAT-2024-21", purchasePrice: 42.0, sellingPrice: 75.0, quantity: 60, minStockThreshold: 20, expiryDate: "2027-08-09", distributorName: "Global Bio-Health Logistics"),
    Medicine(id: "M22", name: "Clopidogrel 75mg", company: "Sun Pharma", category: "Cardiovascular", batchNumber: "BAT-2024-22", purchasePrice: 55.0, sellingPrice: 98.0, quantity: 80, minStockThreshold: 15, expiryDate: "2027-10-05", distributorName: "Titan Healthcare Distributors"),
    Medicine(id: "M23", name: "Aceclofenac + Paracetamol (Zerodol-P)", company: "Ipca Labs", category: "Analgesics", batchNumber: "BAT-2024-23", purchasePrice: 30.0, sellingPrice: 58.0, quantity: 230, minStockThreshold: 40, expiryDate: "2028-05-19", distributorName: "Vanguard Lifesciences"),
    Medicine(id: "M24", name: "Doxycycline 100mg", company: "USV Ltd", category: "Antibiotics", batchNumber: "BAT-2024-24", purchasePrice: 28.0, sellingPrice: 50.0, quantity: 95, minStockThreshold: 20, expiryDate: "2027-03-14", distributorName: "Reliance Pharma Stockists"),
    Medicine(id: "M25", name: "Metoprolol 50mg", company: "AstraZeneca", category: "Cardiovascular", batchNumber: "BAT-2024-25", purchasePrice: 48.0, sellingPrice: 88.0, quantity: 110, minStockThreshold: 25, expiryDate: "2027-09-27", distributorName: "CityMed Agencies"),
    Medicine(id: "M26", name: "Salbutamol Inhaler (Asthalin)", company: "Cipla Ltd", category: "Respiratory", batchNumber: "BAT-2024-26", purchasePrice: 85.0, sellingPrice: 150.0, quantity: 65, minStockThreshold: 15, expiryDate: "2027-07-10", distributorName: "Matrix Lifecare Depot"),
    Medicine(id: "M27", name: "Fluconazole 150mg", company: "Glenmark", category: "Dermatology", batchNumber: "BAT-2024-27", purchasePrice: 18.0, sellingPrice: 36.0, quantity: 140, minStockThreshold: 20, expiryDate: "2028-01-05", distributorName: "Zenith Medical Corp"),
    Medicine(id: "M28", name: "Ofloxacin + Ornidazole (Oflomac M)", company: "Mankind Pharma", category: "Antibiotics", batchNumber: "BAT-2024-28", purchasePrice: 45.0, sellingPrice: 82.0, quantity: 9, minStockThreshold: 25, expiryDate: "2027-06-12", distributorName: "Horizon Pharma Traders"),
    Medicine(id: "M29", name: "Rosuvastatin 10mg", company: "Sun Pharma", category: "Cardiovascular", batchNumber: "BAT-2024-29", purchasePrice: 70.0, sellingPrice: 125.0, quantity: 115, minStockThreshold: 20, expiryDate: "2027-12-20", distributorName: "Sovereign Health Supplies"),
    Medicine(id: "M30", name: "Hydrochlorothiazide 12.5mg", company: "Lupin Pharma", category: "Cardiovascular", batchNumber: "BAT-2024-30", purchasePrice: 12.0, sellingPrice: 24.0, quantity: 160, minStockThreshold: 30, expiryDate: "2028-04-02", distributorName: "Unicorn Pharma Logistics"),
    Medicine(id: "M31", name: "Budesonide Respules (Budecort)", company: "Cipla Ltd", category: "Respiratory", batchNumber: "BAT-2024-31", purchasePrice: 120.0, sellingPrice: 210.0, quantity: 50, minStockThreshold: 15, expiryDate: "2027-08-30", distributorName: "Everest Medical Wholesale"),
    Medicine(id: "M32", name: "Rabeprazole 20mg (Rabeloc)", company: "Cadila Healthcare", category: "Gastrointestinal", batchNumber: "BAT-2024-32", purchasePrice: 36.0, sellingPrice: 66.0, quantity: 185, minStockThreshold: 35, expiryDate: "2027-10-18", distributorName: "MedLife Wholesale Traders"),
    Medicine(id: "M33", name: "Clobetasol Propionate Cream (Tenovate)", company: "GlaxoSmithKline", category: "Dermatology", batchNumber: "BAT-2024-33", purchasePrice: 40.0, sellingPrice: 75.0, quantity: 70, minStockThreshold: 20, expiryDate: "2027-05-24", distributorName: "Apex Health Pharma Distributors"),
    Medicine(id: "M34", name: "Multivitamin & Mineral Capsules (Becosules)", company: "Pfizer Ltd", category: "Vitamins & Supplements", batchNumber: "BAT-2024-34", purchasePrice: 25.0, sellingPrice: 48.0, quantity: 310, minStockThreshold: 50, expiryDate: "2028-06-15", distributorName: "Sunshine Medical Agencies"),
    Medicine(id: "M35", name: "Vildagliptin 50mg (Galvus)", company: "Novartis", category: "Antidiabetic", batchNumber: "BAT-2024-35", purchasePrice: 140.0, sellingPrice: 240.0, quantity: 45, minStockThreshold: 15, expiryDate: "2027-09-01", distributorName: "CareMed Pharma Supplies"),
    Medicine(id: "M36", name: "Sitagliptin 100mg (Januvia)", company: "MSD Pharma", category: "Antidiabetic", batchNumber: "BAT-2024-36", purchasePrice: 180.0, sellingPrice: 310.0, quantity: 38, minStockThreshold: 10, expiryDate: "2027-11-10", distributorName: "Global Bio-Health Logistics"),
    Medicine(id: "M37", name: "Linezolid 600mg", company: "Glenmark", category: "Antibiotics", batchNumber: "BAT-2024-37", purchasePrice: 210.0, sellingPrice: 380.0, quantity: 22, minStockThreshold: 10, expiryDate: "2027-04-08", distributorName: "Titan Healthcare Distributors"),
    Medicine(id: "M38", name: "Domperidone 10mg (VomiSTOP)", company: "Mankind Pharma", category: "Gastrointestinal", batchNumber: "BAT-2024-38", purchasePrice: 15.0, sellingPrice: 30.0, quantity: 190, minStockThreshold: 30, expiryDate: "2028-02-28", distributorName: "Vanguard Lifesciences"),
    Medicine(id: "M39", name: "Betahistine 16mg (Vertin)", company: "Abbott India", category: "Neurology", batchNumber: "BAT-2024-39", purchasePrice: 65.0, sellingPrice: 118.0, quantity: 80, minStockThreshold: 20, expiryDate: "2027-07-04", distributorName: "Reliance Pharma Stockists"),
    Medicine(id: "M40", name: "Pregabalin 75mg", company: "Torrent Pharma", category: "Neurology", batchNumber: "BAT-2024-40", purchasePrice: 95.0, sellingPrice: 170.0, quantity: 60, minStockThreshold: 15, expiryDate: "2027-10-29", distributorName: "CityMed Agencies"),
    Medicine(id: "M41", name: "Gabapentin 300mg", company: "Intas Pharma", category: "Neurology", batchNumber: "BAT-2024-41", purchasePrice: 88.0, sellingPrice: 155.0, quantity: 52, minStockThreshold: 15, expiryDate: "2027-08-12", distributorName: "Matrix Lifecare Depot"),
    Medicine(id: "M42", name: "Tramadol 50mg", company: "Cadila Healthcare", category: "Analgesics", batchNumber: "BAT-2024-42", purchasePrice: 32.0, sellingPrice: 60.0, quantity: 75, minStockThreshold: 20, expiryDate: "2027-09-15", distributorName: "Zenith Medical Corp"),
    Medicine(id: "M43", name: "ONDANSETRON 4mg (Emset)", company: "Cipla Ltd", category: "Gastrointestinal", batchNumber: "BAT-2024-43", purchasePrice: 18.0, sellingPrice: 35.0, quantity: 140, minStockThreshold: 30, expiryDate: "2028-03-10", distributorName: "Horizon Pharma Traders"),
    Medicine(id: "M44", name: "Spironolactone 25mg (Aldactone)", company: "RPG Life Sciences", category: "Cardiovascular", batchNumber: "BAT-2024-44", purchasePrice: 22.0, sellingPrice: 42.0, quantity: 90, minStockThreshold: 20, expiryDate: "2027-12-05", distributorName: "Sovereign Health Supplies"),
    Medicine(id: "M45", name: "Nifedipine 20mg", company: "JB Chemicals", category: "Cardiovascular", batchNumber: "BAT-2024-45", purchasePrice: 26.0, sellingPrice: 48.0, quantity: 110, minStockThreshold: 25, expiryDate: "2028-01-18", distributorName: "Unicorn Pharma Logistics"),
    Medicine(id: "M46", name: "Silver Sulfadiazine Cream (Burnol)", company: "Morepen Labs", category: "Dermatology", batchNumber: "BAT-2024-46", purchasePrice: 30.0, sellingPrice: 55.0, quantity: 85, minStockThreshold: 20, expiryDate: "2027-06-20", distributorName: "Everest Medical Wholesale"),
    Medicine(id: "M47", name: "Chlorpheniramine Maleate (Piriton)", company: "GlaxoSmithKline", category: "Antihistamine", batchNumber: "BAT-2024-47", purchasePrice: 6.0, sellingPrice: 14.0, quantity: 220, minStockThreshold: 40, expiryDate: "2028-04-25", distributorName: "MedLife Wholesale Traders"),
    Medicine(id: "M48", name: "Orlistat 120mg", company: "Biocon Ltd", category: "Metabolic", batchNumber: "BAT-2024-48", purchasePrice: 220.0, sellingPrice: 390.0, quantity: 18, minStockThreshold: 10, expiryDate: "2027-11-22", distributorName: "Apex Health Pharma Distributors"),
    Medicine(id: "M49", name: "Clotrimazole Dusting Powder (Candid)", company: "Glenmark", category: "Dermatology", batchNumber: "BAT-2024-49", purchasePrice: 50.0, sellingPrice: 92.0, quantity: 130, minStockThreshold: 25, expiryDate: "2028-05-12", distributorName: "Sunshine Medical Agencies"),
    Medicine(id: "M50", name: "ORS Electrolyte Powder", company: "FDC Ltd", category: "Nutritional", batchNumber: "BAT-2024-50", purchasePrice: 12.0, sellingPrice: 22.0, quantity: 500, minStockThreshold: 100, expiryDate: "2028-07-30", distributorName: "CareMed Pharma Supplies"),
  ];

  static List<PurchaseRecord> generatePurchases() {
    final List<PurchaseRecord> list = [];
    final random = Random();
    int count = 1001;
    for (int i = 1; i <= 100; i++) {
      final med = initialMedicines[i % initialMedicines.length];
      final qty = 20 + random.nextInt(181);
      final day = (1 + random.nextInt(28)).toString().padLeft(2, '0');
      final month = (1 + random.nextInt(7)).toString().padLeft(2, '0');
      final date = "2026-$month-$day";
      list.add(
        PurchaseRecord(
          id: "P$count",
          invoiceNumber: "INV-PUR-2026-$count",
          distributorName: med.distributorName,
          purchaseDate: date,
          medicineId: med.id,
          medicineName: med.name,
          quantity: qty,
          purchasePrice: med.purchasePrice,
          expiryDate: med.expiryDate,
        ),
      );
      count++;
    }
    return list;
  }

  static List<SaleRecord> generateSales() {
    final List<SaleRecord> list = [];
    final random = Random();
    int count = 5001;
    final paymentModes = ["UPI", "Cash", "Credit Card", "Debit Card"];
    final customers = ["Walk-in Customer", "Ramesh Kumar", "Priya Sharma", "Amit Patel", "Sneha Gupta", "Dr. Rajesh Verma", "Sunita Rao"];

    for (int i = 1; i <= 100; i++) {
      final item1 = initialMedicines[i % initialMedicines.length];
      final item2 = initialMedicines[(i + 3) % initialMedicines.length];
      final qty1 = 1 + random.nextInt(5);
      final qty2 = 1 + random.nextInt(3);

      final saleItems = [
        SaleItem(medicineId: item1.id, medicineName: item1.name, quantity: qty1, unitPrice: item1.sellingPrice),
        SaleItem(medicineId: item2.id, medicineName: item2.name, quantity: qty2, unitPrice: item2.sellingPrice),
      ];
      final total = saleItems.fold(0.0, (sum, item) => sum + item.itemTotal);

      final day = (1 + random.nextInt(24)).toString().padLeft(2, '0');
      final month = (1 + random.nextInt(7)).toString().padLeft(2, '0');
      final date = "2026-$month-$day";

      list.add(
        SaleRecord(
          id: "S$count",
          invoiceNumber: "INV-SL-2026-$count",
          saleDate: date,
          items: saleItems,
          grandTotal: total,
          customerName: customers[random.nextInt(customers.length)],
          paymentMode: paymentModes[random.nextInt(paymentModes.length)],
        ),
      );
      count++;
    }
    return list;
  }
}
