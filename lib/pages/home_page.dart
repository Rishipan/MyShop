// ignore_for_file: use_build_context_synchronously

import 'package:barcode_scan2/gen/protos/protos.pbenum.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myshop/auth/auth.dart';
import 'package:myshop/pages/bills/bills_page.dart';
import 'package:myshop/pages/cart/cart_page.dart';
import 'package:myshop/pages/scan/dialog_box.dart';
import 'package:myshop/pages/stocks/items_page.dart';
import 'package:myshop/pages/notes/notes_page.dart';
import 'package:myshop/utils/my_icon_button.dart';
import 'package:myshop/utils/my_method.dart';

import 'home_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Shop',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 50, 0, 0),
                items: [
                  PopupMenuItem(
                    child: const Text('Settings'),
                    onTap: () {
                      // Navigate to settings or perform an action
                      myMethods.displaySnackBar(
                          'Not enable yet', Colors.grey, context);
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('Logout '),
                    onTap: () {
                      // Perform logout action
                      _logout(context);
                    },
                  ),
                ],
              );
            },
          ),
        ],
        elevation: 4,
        backgroundColor: Colors.green.shade900,
        automaticallyImplyLeading: false,
      ),
      body: const HomeBody(),
      // body: Column(
      //   children: [
      //     const Tile2x2(),
      //     const Tile2x2(),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: [
      //         Container(
      //           height: wid / 4,
      //           width: wid / 4 - 16,
      //           color: Colors.amber,
      //         ),
      //         Container(
      //           height: wid / 4,
      //           width: wid / 4 - 16,
      //           color: Colors.amber,
      //         ),
      //         Container(
      //           height: wid / 4,
      //           width: wid / 4 - 16,
      //           color: Colors.amber,
      //         ),
      //         Container(
      //           height: wid / 4,
      //           width: wid / 4 - 16,
      //           color: Colors.amber,
      //         )
      //       ],
      //     )
      //   ],
      // ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.green.shade900,
        child: Padding(
          padding: const EdgeInsets.only(right: 30, left: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyIconButton(
                icon: const Icon(Icons.list_alt_outlined),
                text: 'Stocks',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const StockPage()),
                  );
                },
              ),
              MyIconButton(
                icon: const Icon(Icons.note_alt_outlined),
                text: 'Notes',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const NotesPage()),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ]),
                child: MyIconButton(
                  icon: const Icon(Icons.qr_code_scanner_outlined),
                  text: 'Scan',
                  onTap: () async {
                    var result = await BarcodeScanner.scan();

                    if (result.type == ResultType.Barcode) {
                      if (result.rawContent.isNotEmpty) {
                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;
                        try {
                          QuerySnapshot<Map<String, dynamic>> barcodeQuery =
                              await firestore
                                  .collection('shops')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('stocks')
                                  .where('barcode',
                                      isEqualTo: result.rawContent)
                                  .get();
                          if (barcodeQuery.docs.isNotEmpty) {
                            var existingStock = barcodeQuery.docs.first.data();
                            String barcode = result.rawContent;
                            String stockName = existingStock['stock_name'];
                            int units = existingStock['units_left'].toInt();
                            double profitPerUnit =
                                existingStock['profit_per_unit'].toDouble();
                            double price =
                                existingStock['sell_price'].toDouble();

                            String category = existingStock['category'];
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return DialogBox(
                                barcode: barcode,
                                name: stockName,
                                category: category,
                                price: price,
                                unitsAvailable: units,
                                profitRate: profitPerUnit,
                              );
                            }));
                          } else {
                            myMethods.displaySnackBar(
                                "Product not present!", Colors.red, context);
                          }
                        } catch (e) {
                          myMethods.displaySnackBar(
                              "Error while saving data: ${e.toString()}",
                              Colors.red,
                              context);
                        }
                      }
                    }
                  },
                ),
              ),
              MyIconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                text: 'Cart',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
              ),
              MyIconButton(
                icon: const Icon(Icons.receipt),
                text: 'Bills',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const BillsPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(
      //     bottom: 60,
      //   ),
      //   child: FloatingActionButton(
      //     onPressed: () {},
      //     child: const Icon(Icons.qr_code_scanner_outlined),
      //   ),
      // ),
    );
  }

  MyMethods myMethods = MyMethods();

  _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthPage()),
        (Route<dynamic> route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Loged out successfully'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    } catch (e) {
      myMethods.displaySnackBar('Error signing out: $e', Colors.red, context);
    }
  }
}
