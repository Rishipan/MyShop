// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/my_button.dart';
import '../../utils/my_method.dart';
import '../home_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        automaticallyImplyLeading: false,
        title: Text(
          'Cart',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: _clearCart,
              icon: const Icon(Icons.delete, color: Colors.white),
            ),
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('shops')
            .doc(FirebaseAuth.instance.currentUser?.uid ?? '')
            .collection('cart')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: SpinKitCircle(
              color: Colors.green.shade900,
            ));
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
          final items = snapshot.data!.docs;
          final sortedItems = items
            ..sort((a, b) => a['name'].compareTo(b['name']));
          double totalPrice = 0;

          for (var item in items) {
            totalPrice +=
                (item['sell_price']).toDouble() * (item['units']).toDouble();
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: sortedItems.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item['name']} x ${item['units']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900,
                            ),
                          ),
                          Text(
                            'Price: ₹${item['sell_price']}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MyButton(
                  onTap: () async {
                    if (isLoading == false) {
                      await _makeTransaction(context);
                    }
                    if (mounted) {
                      setState(() {
                        isLoading = true;
                      });
                    }
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  text: '₹$totalPrice',
                  color: Colors.green.shade700,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  MyMethods myMethods = MyMethods();

  Future<void> _makeTransaction(BuildContext context) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }
      final cartCollection = FirebaseFirestore.instance
          .collection('shops')
          .doc(userId)
          .collection('cart');
      final stockCollection = FirebaseFirestore.instance
          .collection('shops')
          .doc(userId)
          .collection('stocks');

      final cartItems = await cartCollection.get();
      final stockItems = await stockCollection.get();

      if (cartItems.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cart is empty')),
        );
        return;
      }

      double totalPrice = 0;
      double totalProfit = 0;
      List<Map<String, dynamic>> items = [];

      for (var item in cartItems.docs) {
        final itemData = item.data();
        totalPrice += (itemData['sell_price'] ?? 0).toDouble() *
            (itemData['units'] ?? 0).toDouble();
        totalProfit += (itemData['profit_rate'] ?? 0).toDouble() *
            (itemData['units'] ?? 0).toDouble();
        // update stocks
        final String barcode = itemData['barcode'];
        final stockItem = stockItems.docs.firstWhere(
          (stock) => stock['barcode'] == barcode,
          orElse: () =>
              throw Exception('Stock item not found for barcode: $barcode'),
        );

        if (stockItem != null) {
          final stockData = stockItem.data();
          final updatedUnits =
              (stockData['units_left'] as int) - (itemData['units'] as int);

          if (updatedUnits >= 0) {
            await FirebaseFirestore.instance
                .collection('shops')
                .doc(userId)
                .collection('stocks')
                .doc(stockItem.id)
                .update({
              'units_left': updatedUnits,
              'units_sold':
                  (stockData['units_sold'] as int) + (itemData['units'] as int),
              'total_sell': (stockData['total_sell'] ?? 0).toDouble() +
                  ((itemData['sell_price'] ?? 0).toDouble() *
                      (itemData['units'] ?? 0).toDouble()),
              'total_profit': (stockData['total_profit'] ?? 0).toDouble() +
                  ((itemData['profit_rate'] ?? 0).toDouble() *
                      (itemData['units'] ?? 0).toDouble()),
            });
          } else {
            throw Exception('Insufficient stock for ${itemData['name']}');
          }
        } else {
          throw Exception('Stock item not found for barcode: $barcode');
        }

        items.add({
          'name': itemData['name'],
          'units': itemData['units'],
          'category': itemData['category'],
          'sell_price': itemData['sell_price'],
        });
      }

      final transactionData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'items': items,
        'total_price': totalPrice,
        'total_profit': totalProfit,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('shops')
          .doc(userId)
          .collection('transactions')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set(transactionData);

      // Clear the cart after transaction
      for (var item in cartItems.docs) {
        await item.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction completed successfully')),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error hai to: $e')),
        );
      }
    }
  }

  _clearCart() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final cartCollection = FirebaseFirestore.instance
          .collection('shops')
          .doc(userId)
          .collection('cart');

      final cartItems = await cartCollection.get();

      if (cartItems.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cart is already empty')),
        );
        return;
      }

      for (var item in cartItems.docs) {
        await item.reference.delete();
      }

      myMethods.displaySnackBar(
          'Cart cleared successfully', Colors.grey, context);
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        myMethods.displaySnackBar('Error: $e', Colors.red, context);
      }
    }
  }
}
