// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/my_method.dart';

class DialogBox extends StatefulWidget {
  final String barcode;
  final String name;
  final String category;
  final double price;
  final int unitsAvailable;
  final double profitRate;
  const DialogBox(
      {super.key,
      required this.barcode,
      required this.name,
      required this.price,
      required this.category,
      required this.unitsAvailable,
      required this.profitRate});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  final unitsController = TextEditingController();

  MyMethods myMethods = MyMethods();

  _addToCart(BuildContext context, String name, String barcode, String category,
      int unitsAvailabe, int units, double price, double profitRate) async {
    if (unitsAvailabe < units) {
      myMethods.displaySnackBar(
          "Sorry only $unitsAvailabe units left", Colors.grey, context);
    } else {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      try {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await firestore
              .collection('shops')
              .doc(currentUser.uid)
              .collection('cart')
              .doc(barcode)
              .set({
            'name': name,
            'barcode': barcode,
            'units': units,
            'sell_price': price,
            'category': category,
            'profit_rate': profitRate
          });
          // MyLoading(messageText: '$name x $units added to cart');
        } else {
          myMethods.displaySnackBar(
              'Sorry I\'m unable to add the item', Colors.blue, context);
        }
      } catch (e) {
        myMethods.displaySnackBar("...", Colors.red, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green.shade100,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green.shade900,
                ),
              ),
              Text(
                widget.barcode,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green.shade400,
                ),
              ),
              Text(
                "Price: ${widget.price}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: TextField(
                    controller: unitsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Units",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    cursorColor: Colors.black,
                  )),
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      color: Colors.red.shade700,
                      size: 30,
                    ),
                    onPressed: () {
                      int currentValue =
                          int.tryParse(unitsController.text) ?? 0;
                      if (currentValue > 0) {
                        unitsController.text = (currentValue - 1).toString();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Colors.green.shade700,
                      size: 30,
                    ),
                    onPressed: () {
                      int currentValue =
                          int.tryParse(unitsController.text) ?? 0;
                      unitsController.text = (currentValue + 1).toString();
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                int units = int.tryParse(unitsController.text) ?? 0;

                await _addToCart(
                    context,
                    widget.name,
                    widget.barcode,
                    widget.category,
                    widget.unitsAvailable,
                    units,
                    widget.price,
                    widget.profitRate);
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.green.shade700)),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
