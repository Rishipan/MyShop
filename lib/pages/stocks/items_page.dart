import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myshop/pages/stocks/add_item.dart';
import 'package:myshop/pages/stocks/edit_stock_page.dart';
import 'package:myshop/utils/tiles/stock_tile.dart';

class StockPage extends StatelessWidget {
  const StockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stocks',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        elevation: 4,
        backgroundColor: Colors.green.shade900,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('shops')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('stocks')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitCircle(
              color: Colors.green.shade900,
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No items found'),
            );
          }
          final stocks = snapshot.data!.docs;
          final sortedStocks = stocks
            ..sort((a, b) => a['stock_name'].compareTo(b['stock_name']));
          return ListView.builder(
            itemCount: sortedStocks.length,
            itemBuilder: (context, index) {
              final stock = sortedStocks[index];
              return StockTile(
                stockName: stock['stock_name'],
                sellPrice: stock['sell_price'],
                unitsAvailable: stock['units_left'],
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.green.shade300,
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              stock['stock_name'],
                              style: const TextStyle(
                                color: Colors.yellow,
                                // fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ID: ${stock['barcode']}',
                              style: TextStyle(
                                color: Colors.grey.shade100,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        content: Text(
                          'Price: ₹${stock['sell_price']}\nUnits Left: ${stock['units_left']}\nUnits Sold: ${stock['units_sold']}\nTotal Profit: ₹${stock['total_profit'].toStringAsFixed(2)}\nProfit/Unit: ₹${stock['profit_per_unit'].toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            // fontSize: 14,
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () => {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => EditStockPage(
                                        barcode: stock['barcode'],
                                        stockName: stock['stock_name'],
                                        category: stock['category'],
                                        stockPrice: stock['stock_price'],
                                        units: stock['units_left'],
                                        sellPerUnit: stock['sell_price'],
                                        description: stock['description'],
                                        unitsBefore: stock['units_before'])),
                              )
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.green.shade700)),
                            child: const Text(
                              'Edit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.green.shade700)),
                            child: const Text(
                              'Close',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddStock()),
          );
        },
        label: const Text("+ Add Items"),
      ),
    );
  }
}
