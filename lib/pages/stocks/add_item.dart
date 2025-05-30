// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myshop/utils/my_method.dart';

import '../../utils/my_text_field.dart';

import 'package:barcode_scan2/gen/protos/protos.pbenum.dart';
import 'package:barcode_scan2/platform_wrapper.dart';

import 'items_page.dart';

class AddStock extends StatefulWidget {
  const AddStock({super.key});

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Stock',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.green.shade900,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: () async {
                await _addStock();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('SAVE'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 32,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    MyTextField(
                      controller: barCodeController,
                      labelText: 'Barcode No.',
                      obscureText: false,
                      textinputtype: TextInputType.number,
                    ),
                    Positioned(
                      right: 32,
                      child: IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: () async {
                          try {
                            var result = await BarcodeScanner.scan();
                            if (result.type == ResultType.Barcode) {
                              barCodeController.text = result.rawContent;
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    MyTextField(
                      controller: categoryController,
                      labelText: 'Category',
                      obscureText: false,
                      textinputtype: TextInputType.none,
                    ),
                    Positioned(
                      right: 32,
                      child: IconButton(
                        onPressed: () {
                          showMenu(
                            context: context,
                            color: Colors.green.shade200,
                            position: RelativeRect.fromLTRB(
                                MediaQuery.of(context).size.width - 100,
                                100,
                                10,
                                0),
                            items: [
                              const PopupMenuItem(
                                value: 'Chocolates',
                                child: Text('Chocolates'),
                              ),
                              const PopupMenuItem(
                                value: 'Drinks',
                                child: Text('Drinks'),
                              ),
                              const PopupMenuItem(
                                value: 'Ice Creams',
                                child: Text('Ice Creams'),
                              ),
                              const PopupMenuItem(
                                value: 'Snacks',
                                child: Text('Snacks'),
                              ),
                              const PopupMenuItem(
                                value: 'Others',
                                child: Text('Others'),
                              ),
                            ],
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                categoryController.text = value;
                              });
                            }
                          });
                        },
                        icon: const Icon(Icons.select_all_outlined),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: stockNameController,
                  labelText: 'Stock Name',
                  obscureText: false,
                  textinputtype: TextInputType.text,
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: stockPriceController,
                  labelText: 'Stock Price (₹)',
                  obscureText: false,
                  textinputtype: TextInputType.number,
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: unitsController,
                  labelText: 'Units (x)',
                  obscureText: false,
                  textinputtype: TextInputType.number,
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: sellPriceController,
                  labelText: 'Sell/Unit (₹)',
                  obscureText: false,
                  textinputtype: TextInputType.number,
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: descriptionController,
                  labelText: 'Description (Optional)',
                  obscureText: false,
                  textinputtype: TextInputType.text,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final barCodeController = TextEditingController();
  final categoryController = TextEditingController();
  final stockNameController = TextEditingController();
  final stockPriceController = TextEditingController();
  final unitsController = TextEditingController();
  final sellPriceController = TextEditingController();
  final descriptionController = TextEditingController();
  MyMethods myMethods = MyMethods();

  _addStock() {
    myMethods.checkConnectivity(context);
    if (barCodeController.text.trim().isEmpty) {
      myMethods.displaySnackBar('Please enter barcode...', Colors.red, context);
    } else if (categoryController.text.trim().isEmpty) {
      myMethods.displaySnackBar(
          'Please select category...', Colors.red, context);
    } else if (stockNameController.text.trim().isEmpty) {
      myMethods.displaySnackBar(
          'Please enter product name...', Colors.red, context);
    } else if (double.tryParse(stockPriceController.text.trim()) == null ||
        double.parse(stockPriceController.text.trim()) <= 0) {
      myMethods.displaySnackBar(
          'Please enter valid stock price...', Colors.red, context);
    } else if (int.tryParse(unitsController.text.trim()) == null ||
        int.parse(unitsController.text.trim()) <= 0) {
      myMethods.displaySnackBar(
          'Please enter valid units...', Colors.red, context);
    } else if (double.tryParse(sellPriceController.text.trim()) == null ||
        double.parse(sellPriceController.text.trim()) <= 0) {
      myMethods.displaySnackBar(
          'Please enter valid stock price...', Colors.red, context);
    } else {
      _saveStockToFirestore();
    }
  }

  _saveStockToFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String currentBarcode = barCodeController.text.trim();
    String currentCategory = categoryController.text.trim();
    String currentStockName = stockNameController.text.trim();
    double currentStockPrice = double.parse(stockPriceController.text.trim());
    double currentSellPrice = double.parse(sellPriceController.text.trim());
    int currentUnits = int.parse(unitsController.text.trim());
    String currentDescription = descriptionController.text.trim();

    double profitPerUnit =
        ((currentSellPrice * currentUnits) - currentStockPrice) / currentUnits;

    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    try {
      QuerySnapshot<Map<String, dynamic>> barcodeQuery = await firestore
          .collection('shops')
          .doc(currentUser)
          .collection('stocks')
          .where('barcode', isEqualTo: currentBarcode)
          .get();
      if (barcodeQuery.docs.isNotEmpty) {
        var existingStock = barcodeQuery.docs.first.data();

        int existingUnits = (existingStock['units_left'] ?? 0);

        int updatedUnits = existingUnits + currentUnits;

        await firestore
            .collection('shops')
            .doc(currentUser)
            .collection('stocks')
            .doc(currentBarcode)
            .update({
          'category': currentCategory,
          'stock_name': currentStockName,
          'stock_price': currentStockPrice,
          'units_left': updatedUnits,
          'units_before': existingUnits,
          'sell_price': currentSellPrice,
          'profit_per_unit': profitPerUnit,
          'description': currentDescription,
        });
      } else {
        double totalProfit = 0;
        int unitsSold = 0;

        await firestore
            .collection('shops')
            .doc(currentUser)
            .collection('stocks')
            .doc(currentBarcode)
            .set({
          'barcode': currentBarcode,
          'category': currentCategory,
          'stock_name': currentStockName,
          'stock_price': currentStockPrice,
          'units_left': currentUnits,
          'units_sold': unitsSold,
          'units_before': 0,
          'sell_price': currentSellPrice,
          'total_profit': totalProfit,
          'profit_per_unit': profitPerUnit,
          'description': currentDescription,
        });
      }

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const StockPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock added...')),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
