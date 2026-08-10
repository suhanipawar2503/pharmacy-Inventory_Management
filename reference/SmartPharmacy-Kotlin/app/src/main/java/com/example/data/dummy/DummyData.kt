package com.example.data.dummy

import com.example.data.model.Distributor
import com.example.data.model.Medicine
import com.example.data.model.PurchaseRecord
import com.example.data.model.SaleItem
import com.example.data.model.SaleRecord

object DummyData {

    val initialDistributors = listOf(
        Distributor("D01", "MedLife Wholesale Traders", "+91 98230 11223", "Plot 42, Pharma Zone, Industrial Area, Mumbai", "27AAAAA0000A1Z5", "orders@medlifewholesale.com"),
        Distributor("D02", "Apex Health Pharma Distributors", "+91 98450 33445", "102 Central Avenue, Connaught Place, New Delhi", "07BBBCA1111B2Z4", "supply@apexpharma.in"),
        Distributor("D03", "Sunshine Medical Agencies", "+91 97110 55667", "Sector 18, Commercial Hub, Gurugram", "06CCCDE2222C3Z3", "contact@sunshinemedical.com"),
        Distributor("D04", "CareMed Pharma Supplies", "+91 99880 77889", "88 Ring Road, Near General Hospital, Ahmedabad", "24DDDDF3333D4Z2", "caremed.ahd@gmail.com"),
        Distributor("D05", "Global Bio-Health Logistics", "+91 94220 99001", "Building C, Trade Center, Bengaluru", "29EEEEG4444E5Z1", "sales@globalbiohealth.org"),
        Distributor("D06", "Titan Healthcare Distributors", "+91 98900 12345", "15 Market Yard, Pune", "27FFFFH5555F6Z0", "orders@titanhealth.com"),
        Distributor("D07", "Vanguard Lifesciences", "+91 91234 56789", "5th Cross, Malleshwaram, Bengaluru", "29GGGGJ6666G7Z9", "info@vanguardlife.in"),
        Distributor("D08", "Reliance Pharma Stockists", "+91 93456 78901", "GIDC Estate, Vadodara", "24HHHHK7777H8Z8", "sales@reliancepharma.com"),
        Distributor("D09", "CityMed Agencies", "+91 94567 89012", "MG Road, Zone 2, Bhopal", "23JJJJL8888J9Z7", "citymed.bhopal@yahoo.com"),
        Distributor("D10", "Matrix Lifecare Depot", "+91 95678 90123", "Station Road, Jaipur", "08KKKKM9999K0Z6", "support@matrixlifecare.com"),
        Distributor("D11", "Zenith Medical Corp", "+91 96789 01234", "Park Street, Kolkata", "19LLLLN1010L1Z5", "zenith.med@gmail.com"),
        Distributor("D12", "Horizon Pharma Traders", "+91 97890 12345", "Banjara Hills, Hyderabad", "36MMMMO2020M2Z4", "horizonpharma@hyderabad.com"),
        Distributor("D13", "Sovereign Health Supplies", "+91 98901 23456", "Anna Salai, Chennai", "33NNNNP3030N3Z3", "orders@sovereignhealth.in"),
        Distributor("D14", "Unicorn Pharma Logistics", "+91 99012 34567", "GS Road, Guwahati", "18PPPPR4040P4Z2", "guwahati@unicornpharma.com"),
        Distributor("D15", "Everest Medical Wholesale", "+91 90123 45678", "Mall Road, Chandigarh", "04QQQQT5050Q5Z1", "everest.pharma@gmail.com")
    )

    val initialMedicines = listOf(
        Medicine("M01", "Amoxicillin 500mg", "Cipla Ltd", "Antibiotics", "BAT-2024-01", 35.0, 52.0, 150, 20, "2027-08-15", "MedLife Wholesale Traders"),
        Medicine("M02", "Paracetamol 650mg (Dolo)", "Micro Labs", "Analgesics", "BAT-2024-02", 12.0, 28.0, 320, 50, "2028-01-20", "Apex Health Pharma Distributors"),
        Medicine("M03", "Azithromycin 500mg", "Zydus Cadila", "Antibiotics", "BAT-2023-99", 60.0, 115.0, 12, 25, "2026-08-10", "MedLife Wholesale Traders"), // Expiring soon
        Medicine("M04", "Metformin 500mg", "Sun Pharma", "Antidiabetic", "BAT-2023-88", 18.0, 32.0, 8, 30, "2026-08-02", "Sunshine Medical Agencies"), // Expiring soon & Low stock
        Medicine("M05", "Pantoprazole 40mg (Pan-40)", "Alkem Labs", "Gastrointestinal", "BAT-2024-05", 45.0, 78.0, 210, 40, "2027-11-30", "CareMed Pharma Supplies"),
        Medicine("M06", "Atorvastatin 10mg", "Lupin Pharma", "Cardiovascular", "BAT-2024-06", 52.0, 95.0, 90, 20, "2027-05-18", "Global Bio-Health Logistics"),
        Medicine("M07", "Cetirizine 10mg (Okacet)", "Cipla Ltd", "Antihistamine", "BAT-2023-45", 8.0, 18.0, 0, 30, "2026-05-10", "Titan Healthcare Distributors"), // Expired & Out of stock
        Medicine("M08", "Ciprofloxacin 500mg", "Dr. Reddy's", "Antibiotics", "BAT-2023-12", 28.0, 48.0, 5, 20, "2026-08-18", "Vanguard Lifesciences"), // Expiring soon & Low stock
        Medicine("M09", "Telmisartan 40mg", "Torrent Pharma", "Cardiovascular", "BAT-2024-09", 40.0, 72.0, 180, 30, "2027-10-12", "Reliance Pharma Stockists"),
        Medicine("M10", "Vitamin C + Zinc (Celin)", "Abbott India", "Vitamins & Supplements", "BAT-2024-10", 15.0, 35.0, 450, 60, "2028-03-25", "CityMed Agencies"),
        Medicine("M11", "Ibuprofen 400mg (Brufen)", "Abbott India", "Analgesics", "BAT-2023-01", 10.0, 22.0, 3, 25, "2026-04-12", "Matrix Lifecare Depot"), // Expired & Low stock
        Medicine("M12", "Montelukast + Levocetirizine", "Mankind Pharma", "Respiratory", "BAT-2024-12", 65.0, 110.0, 85, 20, "2027-09-08", "Zenith Medical Corp"),
        Medicine("M13", "Omeprazole 20mg", "Torrent Pharma", "Gastrointestinal", "BAT-2024-13", 22.0, 42.0, 140, 30, "2027-12-01", "Horizon Pharma Traders"),
        Medicine("M14", "Losartan Potassium 50mg", "Sun Pharma", "Cardiovascular", "BAT-2024-14", 38.0, 68.0, 95, 20, "2027-07-22", "Sovereign Health Supplies"),
        Medicine("M15", "Amlodipine 5mg", "Pfizer Ltd", "Cardiovascular", "BAT-2024-15", 14.0, 28.0, 260, 40, "2028-02-14", "Unicorn Pharma Logistics"),
        Medicine("M16", "Calcium + Vitamin D3 (Shelcal)", "Torrent Pharma", "Vitamins & Supplements", "BAT-2024-16", 72.0, 130.0, 110, 25, "2027-06-30", "Everest Medical Wholesale"),
        Medicine("M17", "Amoxicillin + Clavulanic Acid (Augmentin 625)", "GlaxoSmithKline", "Antibiotics", "BAT-2024-17", 110.0, 185.0, 70, 15, "2026-08-22", "MedLife Wholesale Traders"), // Expiring soon
        Medicine("M18", "Ranitidine 150mg (Aciloc)", "Cadila Healthcare", "Gastrointestinal", "BAT-2023-02", 9.0, 18.0, 15, 20, "2026-03-20", "Apex Health Pharma Distributors"), // Expired
        Medicine("M19", "Diclofenac Sodium 50mg (Voveran)", "Novartis", "Analgesics", "BAT-2024-19", 25.0, 46.0, 130, 25, "2027-04-11", "Sunshine Medical Agencies"),
        Medicine("M20", "Levothyroxine 50mcg (Thyronorm)", "Abbott India", "Endocrinology", "BAT-2024-20", 80.0, 145.0, 175, 30, "2027-11-15", "CareMed Pharma Supplies"),
        Medicine("M21", "Glimepiride 2mg", "Sanofi India", "Antidiabetic", "BAT-2024-21", 42.0, 75.0, 60, 20, "2027-08-09", "Global Bio-Health Logistics"),
        Medicine("M22", "Clopidogrel 75mg", "Sun Pharma", "Cardiovascular", "BAT-2024-22", 55.0, 98.0, 80, 15, "2027-10-05", "Titan Healthcare Distributors"),
        Medicine("M23", "Aceclofenac + Paracetamol (Zerodol-P)", "Ipca Labs", "Analgesics", "BAT-2024-23", 30.0, 58.0, 230, 40, "2028-05-19", "Vanguard Lifesciences"),
        Medicine("M24", "Doxycycline 100mg", "USV Ltd", "Antibiotics", "BAT-2024-24", 28.0, 50.0, 95, 20, "2027-03-14", "Reliance Pharma Stockists"),
        Medicine("M25", "Metoprolol 50mg", "AstraZeneca", "Cardiovascular", "BAT-2024-25", 48.0, 88.0, 110, 25, "2027-09-27", "CityMed Agencies"),
        Medicine("M26", "Salbutamol Inhaler (Asthalin)", "Cipla Ltd", "Respiratory", "BAT-2024-26", 85.0, 150.0, 65, 15, "2027-07-10", "Matrix Lifecare Depot"),
        Medicine("M27", "Fluconazole 150mg", "Glenmark", "Dermatology", "BAT-2024-27", 18.0, 36.0, 140, 20, "2028-01-05", "Zenith Medical Corp"),
        Medicine("M28", "Ofloxacin + Ornidazole (Oflomac M)", "Mankind Pharma", "Antibiotics", "BAT-2024-28", 45.0, 82.0, 9, 25, "2027-06-12", "Horizon Pharma Traders"), // Low stock
        Medicine("M29", "Rosuvastatin 10mg", "Sun Pharma", "Cardiovascular", "BAT-2024-29", 70.0, 125.0, 115, 20, "2027-12-20", "Sovereign Health Supplies"),
        Medicine("M30", "Hydrochlorothiazide 12.5mg", "Lupin Pharma", "Cardiovascular", "BAT-2024-30", 12.0, 24.0, 160, 30, "2028-04-02", "Unicorn Pharma Logistics"),
        Medicine("M31", "Budesonide Respules (Budecort)", "Cipla Ltd", "Respiratory", "BAT-2024-31", 120.0, 210.0, 50, 15, "2027-08-30", "Everest Medical Wholesale"),
        Medicine("M32", "Rabeprazole 20mg (Rabeloc)", "Cadila Healthcare", "Gastrointestinal", "BAT-2024-32", 36.0, 66.0, 185, 35, "2027-10-18", "MedLife Wholesale Traders"),
        Medicine("M33", "Clobetasol Propionate Cream (Tenovate)", "GlaxoSmithKline", "Dermatology", "BAT-2024-33", 40.0, 75.0, 70, 20, "2027-05-24", "Apex Health Pharma Distributors"),
        Medicine("M34", "Multivitamin & Mineral Capsules (Becosules)", "Pfizer Ltd", "Vitamins & Supplements", "BAT-2024-34", 25.0, 48.0, 310, 50, "2028-06-15", "Sunshine Medical Agencies"),
        Medicine("M35", "Vildagliptin 50mg (Galvus)", "Novartis", "Antidiabetic", "BAT-2024-35", 140.0, 240.0, 45, 15, "2027-09-01", "CareMed Pharma Supplies"),
        Medicine("M36", "Sitagliptin 100mg (Januvia)", "MSD Pharma", "Antidiabetic", "BAT-2024-36", 180.0, 310.0, 38, 10, "2027-11-10", "Global Bio-Health Logistics"),
        Medicine("M37", "Linezolid 600mg", "Glenmark", "Antibiotics", "BAT-2024-37", 210.0, 380.0, 22, 10, "2027-04-08", "Titan Healthcare Distributors"),
        Medicine("M38", "Domperidone 10mg (VomiSTOP)", "Mankind Pharma", "Gastrointestinal", "BAT-2024-38", 15.0, 30.0, 190, 30, "2028-02-28", "Vanguard Lifesciences"),
        Medicine("M39", "Betahistine 16mg (Vertin)", "Abbott India", "Neurology", "BAT-2024-39", 65.0, 118.0, 80, 20, "2027-07-04", "Reliance Pharma Stockists"),
        Medicine("M40", "Pregabalin 75mg", "Torrent Pharma", "Neurology", "BAT-2024-40", 95.0, 170.0, 60, 15, "2027-10-29", "CityMed Agencies"),
        Medicine("M41", "Gabapentin 300mg", "Intas Pharma", "Neurology", "BAT-2024-41", 88.0, 155.0, 52, 15, "2027-08-12", "Matrix Lifecare Depot"),
        Medicine("M42", "Tramadol 50mg", "Cadila Healthcare", "Analgesics", "BAT-2024-42", 32.0, 60.0, 75, 20, "2027-09-15", "Zenith Medical Corp"),
        Medicine("M43", "ONDANSETRON 4mg (Emset)", "Cipla Ltd", "Gastrointestinal", "BAT-2024-43", 18.0, 35.0, 140, 30, "2028-03-10", "Horizon Pharma Traders"),
        Medicine("M44", "Spironolactone 25mg (Aldactone)", "RPG Life Sciences", "Cardiovascular", "BAT-2024-44", 22.0, 42.0, 90, 20, "2027-12-05", "Sovereign Health Supplies"),
        Medicine("M45", "Nifedipine 20mg", "JB Chemicals", "Cardiovascular", "BAT-2024-45", 26.0, 48.0, 110, 25, "2028-01-18", "Unicorn Pharma Logistics"),
        Medicine("M46", "Silver Sulfadiazine Cream (Burnol)", "Morepen Labs", "Dermatology", "BAT-2024-46", 30.0, 55.0, 85, 20, "2027-06-20", "Everest Medical Wholesale"),
        Medicine("M47", "Chlorpheniramine Maleate (Piriton)", "GlaxoSmithKline", "Antihistamine", "BAT-2024-47", 6.0, 14.0, 220, 40, "2028-04-25", "MedLife Wholesale Traders"),
        Medicine("M48", "Orlistat 120mg", "Biocon Ltd", "Metabolic", "BAT-2024-48", 220.0, 390.0, 18, 10, "2027-11-22", "Apex Health Pharma Distributors"),
        Medicine("M49", "Clotrimazole Dusting Powder (Candid)", "Glenmark", "Dermatology", "BAT-2024-49", 50.0, 92.0, 130, 25, "2028-05-12", "Sunshine Medical Agencies"),
        Medicine("M50", "ORS Electrolyte Powder", "FDC Ltd", "Nutritional", "BAT-2024-50", 12.0, 22.0, 500, 100, "2028-07-30", "CareMed Pharma Supplies")
    )

    fun generatePurchases(): List<PurchaseRecord> {
        val list = mutableListOf<PurchaseRecord>()
        var count = 1001
        for (i in 1..100) {
            val med = initialMedicines[i % initialMedicines.size]
            val qty = (20..200).random()
            val day = (1..28).random().toString().padStart(2, '0')
            val month = (1..7).random().toString().padStart(2, '0')
            val date = "2026-$month-$day"
            list.add(
                PurchaseRecord(
                    id = "P$count",
                    invoiceNumber = "INV-PUR-2026-$count",
                    distributorName = med.distributorName,
                    purchaseDate = date,
                    medicineId = med.id,
                    medicineName = med.name,
                    quantity = qty,
                    purchasePrice = med.purchasePrice,
                    expiryDate = med.expiryDate,
                    totalAmount = qty * med.purchasePrice
                )
            )
            count++
        }
        return list
    }

    fun generateSales(): List<SaleRecord> {
        val list = mutableListOf<SaleRecord>()
        var count = 5001
        val paymentModes = listOf("UPI", "Cash", "Credit Card", "Debit Card")
        val customers = listOf("Walk-in Customer", "Ramesh Kumar", "Priya Sharma", "Amit Patel", "Sneha Gupta", "Dr. Rajesh Verma", "Sunita Rao")

        for (i in 1..100) {
            val item1 = initialMedicines[i % initialMedicines.size]
            val item2 = initialMedicines[(i + 3) % initialMedicines.size]
            val qty1 = (1..5).random()
            val qty2 = (1..3).random()

            val saleItems = listOf(
                SaleItem(item1.id, item1.name, qty1, item1.sellingPrice),
                SaleItem(item2.id, item2.name, qty2, item2.sellingPrice)
            )
            val total = saleItems.sumOf { it.itemTotal }

            val day = (1..24).random().toString().padStart(2, '0')
            val month = (1..7).random().toString().padStart(2, '0')
            val date = "2026-$month-$day"

            list.add(
                SaleRecord(
                    id = "S$count",
                    invoiceNumber = "INV-SL-2026-$count",
                    saleDate = date,
                    items = saleItems,
                    grandTotal = total,
                    customerName = customers.random(),
                    paymentMode = paymentModes.random()
                )
            )
            count++
        }
        return list
    }
}
