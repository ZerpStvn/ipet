import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServicesAndPricesPage extends StatelessWidget {
  final String documentID;

  const ServicesAndPricesPage({
    Key? key,
    required this.documentID,
  }) : super(key: key);

  // This function fetches the data from Firestore for the given doc ID.
  Future<Map<String, dynamic>?> _fetchServicesData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('pet_services')
          .doc(documentID)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchServicesData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading indicator while fetching data
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          // No data found or error
          return const Center(
            child: Text("No Services or Prices found."),
          );
        }

        final data = snapshot.data!;
        // "servicePrices" is expected to be a Map<String, List<double>>
        // but Firestore returns dynamic, so we must cast carefully:
        final Map<String, dynamic>? pricesMap =
            data['servicePrices'] as Map<String, dynamic>?;

        // If the map is null or empty, show a message
        if (pricesMap == null || pricesMap.isEmpty) {
          return const Center(
            child: Text("No Services or Prices have been added yet."),
          );
        }

        // Convert dynamic map -> Map<String, List<double>>
        final Map<String, List<double>> servicePrices = {};
        pricesMap.forEach((key, value) {
          // "value" might be List<dynamic>, so convert to List<double>
          if (value is List) {
            final converted = value
                .map((item) => item is num ? item.toDouble() : null)
                .whereType<double>()
                .toList();
            servicePrices[key] = converted;
          }
        });

        // Build rows for each service & price
        final List<DataRow> rows = [];

        servicePrices.forEach((service, priceList) {
          // Skip if priceList is empty
          if (priceList.isEmpty) return;

          // If the service has multiple prices, add multiple rows
          for (var price in priceList) {
            rows.add(DataRow(
              cells: [
                DataCell(Text(service)),
                DataCell(Text("\Php${price.toStringAsFixed(2)}")),
              ],
            ));
          }
        });

        // If after filtering, we have no rows, show a message
        if (rows.isEmpty) {
          return const Center(
            child: Text("No Services or Prices have been added yet."),
          );
        }

        // Return a styled table
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Container(
              // On a wide screen, let's give it a max width
              constraints: const BoxConstraints(maxWidth: 600),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  const Color(0xff78AEA8).withOpacity(0.2),
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Service',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Price',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: rows,
              ),
            ),
          ),
        );
      },
    );
  }
}
