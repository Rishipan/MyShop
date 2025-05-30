// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    // double len = screenSize.height;
    double wid = screenSize.width;
    double box1x1 = wid / 4 - 10;
    // double box2x2 = wid / 2 - 12;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Today\'s Products :',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Card(
              color: Colors.pink.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.looks_one_outlined,
                  size: 40,
                  color: Colors.yellow,
                ),
                title: Text('Campa 10/-'),
                subtitle: Text('Profit: rs. 23'),
              ),
            ),
            Card(
              color: Colors.pink.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.looks_two_outlined,
                  size: 40,
                  color: Colors.yellow,
                ),
                title: Text('Campa 10/-'),
                subtitle: Text('Profit: rs. 23'),
              ),
            ),
            Card(
              color: Colors.pink.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.looks_3_outlined,
                  size: 40,
                  color: Colors.yellow,
                ),
                title: Text('Campa 10/-'),
                subtitle: Text('Profit: rs. 23'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.pink.shade100,
                  child: SizedBox(
                    height: box1x1,
                    width: box1x1,
                    child: Center(
                      child: Text(
                        'Card ${index + 1}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Weekly Products :',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Card(
              color: Colors.pink.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.looks_one_outlined,
                  size: 40,
                  color: Colors.yellow,
                ),
                title: Text('Campa 10/-'),
                subtitle: Text('Profit: rs. 23'),
              ),
            ),
            Card(
              color: Colors.pink.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.looks_two_outlined,
                  size: 40,
                  color: Colors.yellow,
                ),
                title: Text('Campa 10/-'),
                subtitle: Text('Profit: rs. 23'),
              ),
            ),
            Card(
              color: Colors.pink.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.looks_3_outlined,
                  size: 40,
                  color: Colors.yellow,
                ),
                title: Text('Campa 10/-'),
                subtitle: Text('Profit: rs. 23'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.pink.shade100,
                  child: SizedBox(
                    height: box1x1,
                    width: box1x1,
                    child: Center(
                      child: Text(
                        'Card ${index + 1}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Monthly Products :',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Card(
              color: Colors.pink.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.looks_one_outlined,
                  size: 40,
                  color: Colors.yellow,
                ),
                title: Text('Campa 10/-'),
                subtitle: Text('Profit: rs. 23'),
              ),
            ),
            Card(
              color: Colors.pink.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.looks_two_outlined,
                  size: 40,
                  color: Colors.yellow,
                ),
                title: Text('Campa 10/-'),
                subtitle: Text('Profit: rs. 23'),
              ),
            ),
            Card(
              color: Colors.pink.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.looks_3_outlined,
                  size: 40,
                  color: Colors.yellow,
                ),
                title: Text('Campa 10/-'),
                subtitle: Text('Profit: rs. 23'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.pink.shade100,
                  child: SizedBox(
                    height: box1x1,
                    width: box1x1,
                    child: Center(
                      child: Text(
                        'Card ${index + 1}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Summary :',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Card(
              color: Colors.pink.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(
                    'Profit: Rs. ${todayTotalProfit?.toStringAsFixed(2) ?? '0.00'}'),
                subtitle: Text(
                    'Collection: Rs. ${todayTotalSell?.toStringAsFixed(2) ?? '0.00'}'),
                trailing: const Text('Today\'s'),
              ),
            ),
            Card(
              color: Colors.pink.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(
                    'Profit: Rs. ${weeklyTotalProfit?.toStringAsFixed(2) ?? '0.00'}'),
                subtitle: Text(
                    'Collection: Rs. ${weeklyTotalSell?.toStringAsFixed(2) ?? '0.00'}'),
                trailing: const Text('Week\'s'),
              ),
            ),
            Card(
              color: Colors.pink.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(
                    'Profit: Rs. ${monthlyTotalProfit?.toStringAsFixed(2) ?? '0.00'}'),
                subtitle: Text(
                    'Collection: Rs. ${monthlyTotalSell?.toStringAsFixed(2) ?? '0.00'}'),
                trailing: const Text('Month\'s'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // today's data
  double? todayTotalProfit;
  double? todayTotalSell;

  String? todayHighestProfitableProduct;
  double? todayHighestProfit;
  int? todayHighestunits;

  String? todaySecondHighestProfitableProduct;
  double? todaySecondHighestProfit;
  int? todaySecondHighestunits;

  String? todayThiredHighestProfitableProduct;
  double? todayThiredHighestProfit;
  int? todayThiredHighestunits;

  // weekly data
  double? weeklyTotalProfit;
  double? weeklyTotalSell;

  String? weeklyHighestProfitableProduct;
  double? weeklyHighestProfit;
  int? weeklyHighestunits;

  String? weeklySecondHighestProfitableProduct;
  double? weeklySecondHighestProfit;
  int? weeklySecondHighestunits;

  String? weeklyThiredHighestProfitableProduct;
  double? weeklyThiredHighestProfit;
  int? weeklyThiredHighestunits;

  // monthly data
  double? monthlyTotalProfit;
  double? monthlyTotalSell;

  String? monthlyHighestProfitableProduct;
  double? monthlyHighestProfit;
  int? monthlyHighestunits;

  String? monthlySecondHighestProfitableProduct;
  double? monthlySecondHighestProfit;
  int? monthlySecondHighestunits;

  String? monthlyThiredHighestProfitableProduct;
  double? monthlyThiredHighestProfit;
  int? monthlyThiredHighestunits;

  Future<void> fetchTransactions() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final transactionsCollection = FirebaseFirestore.instance
          .collection('shops')
          .doc(userId)
          .collection('transactions');

      final transactions = await transactionsCollection.get();

      final sortedTransactions = transactions.docs
        ..sort((a, b) {
          final aTimestamp = (a.data()['timestamp'] as Timestamp?)?.toDate();
          final bTimestamp = (b.data()['timestamp'] as Timestamp?)?.toDate();
          return bTimestamp?.compareTo(aTimestamp ?? DateTime(0)) ?? 0;
        });

      for (var doc in sortedTransactions) {
        final data = doc.data();

        final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
        if (timestamp != null) {
          if (timestamp.year == DateTime.now().year &&
              timestamp.month == DateTime.now().month &&
              timestamp.day == DateTime.now().day) {
            setState(() {
              todayTotalProfit =
                  (todayTotalProfit ?? 0) + (data['total_profit'] ?? 0);
              todayTotalSell =
                  (todayTotalSell ?? 0) + (data['total_price'] ?? 0);
            });
          }
          if (timestamp.weekday <= DateTime.now().weekday &&
              timestamp.isAfter(DateTime.now()
                  .subtract(Duration(days: DateTime.now().weekday - 1)))) {
            setState(() {
              weeklyTotalProfit =
                  (weeklyTotalProfit ?? 0) + (data['total_profit'] ?? 0);
              weeklyTotalSell =
                  (weeklyTotalSell ?? 0) + (data['total_price'] ?? 0);
            });
          }
          if (timestamp.year == DateTime.now().year &&
              timestamp.month == DateTime.now().month) {
            setState(() {
              monthlyTotalProfit =
                  (monthlyTotalProfit ?? 0) + (data['total_profit'] ?? 0);
              monthlyTotalSell =
                  (monthlyTotalSell ?? 0) + (data['total_price'] ?? 0);
            });
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }
}


/*
Future<void> fetchTransactions() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final transactionsCollection = FirebaseFirestore.instance
          .collection('shops')
          .doc(userId)
          .collection('transactions');

      final transactions = await transactionsCollection.get();

      final sortedTransactions = transactions.docs
        ..sort((a, b) {
          final aTimestamp = (a.data()['timestamp'] as Timestamp?)?.toDate();
          final bTimestamp = (b.data()['timestamp'] as Timestamp?)?.toDate();
          return bTimestamp?.compareTo(aTimestamp ?? DateTime(0)) ?? 0;
        });

      for (var doc in sortedTransactions) {
        final data = doc.data();

        final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
        if (timestamp != null) {
          if (timestamp
              .isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
            setState(() {
              todayTotalProfit =
                  (todayTotalProfit ?? 0) + (data['total_profit'] ?? 0);
              todayTotalSell =
                  (todayTotalSell ?? 0) + (data['total_price'] ?? 0);
            });
          }
          if (timestamp
              .isAfter(DateTime.now().subtract(const Duration(days: 7)))) {
            setState(() {
              weeklyTotalProfit =
                  (weeklyTotalProfit ?? 0) + (data['total_profit'] ?? 0);
              weeklyTotalSell =
                  (weeklyTotalSell ?? 0) + (data['total_price'] ?? 0);
            });
          }
          if (timestamp
              .isAfter(DateTime.now().subtract(const Duration(days: 30)))) {
            setState(() {
              monthlyTotalProfit =
                  (monthlyTotalProfit ?? 0) + (data['total_profit'] ?? 0);
              monthlyTotalSell =
                  (monthlyTotalSell ?? 0) + (data['total_price'] ?? 0);
            });
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }
 */