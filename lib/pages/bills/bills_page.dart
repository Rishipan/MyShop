import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myshop/utils/tiles/bills_tile.dart';

class BillsPage extends StatelessWidget {
  const BillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        automaticallyImplyLeading: false,
        title: Text(
          'Bills',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitCircle(color: Colors.green.shade900),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: SpinKitCircle(
              color: Colors.green.shade900,
            ));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final transaction = snapshot.data![index].split('\n');
                final amount =
                    double.tryParse(transaction[0].split(': ')[1]) ?? 0.0;
                final description =
                    'Time: ${transaction[1].split(': ')[1]} \nDate: ${transaction[2].split(': ')[1]} \nID: ${transaction[3].split(': ')[1]}';
                final profit =
                    double.tryParse(transaction[4].split(': ')[1]) ?? 0.0;

                return BillTile(
                  amount: amount,
                  profit: profit,
                  description: description,
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<String>> fetchTransactions() async {
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

      return sortedTransactions.map((doc) {
        final data = doc.data();
        final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
        final formattedDate = timestamp != null
            ? timestamp.toLocal().toString().split(' ')[0]
            : 'Unknown';
        final formattedTime = timestamp != null
            ? timestamp.toLocal().toString().split(' ')[1].substring(0, 8)
            : 'Unknown';
        return 'Amount: ${data['total_price']}\nTime: $formattedTime\nDate: $formattedDate\nTransaction ID: ${doc.id}\nProfit: ${data['total_profit']}';
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
    /*
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final transactionsCollection = FirebaseFirestore.instance
        .collection('shops')
        .doc(userId)
        .collection('transactions');

      final transactions = await transactionsCollection.get();

      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      final filteredTransactions = transactions.docs.where((doc) {
      final timestamp = (doc.data()['timestamp'] as Timestamp?)?.toDate();
      return timestamp != null &&
        timestamp.isAfter(todayStart) &&
        timestamp.isBefore(todayEnd);
      }).toList();

      filteredTransactions.sort((a, b) {
      final aTimestamp = (a.data()['timestamp'] as Timestamp?)?.toDate();
      final bTimestamp = (b.data()['timestamp'] as Timestamp?)?.toDate();
      return bTimestamp?.compareTo(aTimestamp ?? DateTime(0)) ?? 0;
      });

      return filteredTransactions.map((doc) {
      final data = doc.data();
      final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
      final formattedDate = timestamp != null
        ? timestamp.toLocal().toString().split(' ')[0]
        : 'Unknown';
      final formattedTime = timestamp != null
        ? timestamp.toLocal().toString().split(' ')[1].substring(0, 8)
        : 'Unknown';
      return 'Amount: ${data['total_price']}\nTime: $formattedTime\nDate: $formattedDate\nTransaction ID: ${doc.id}\nProfit: ${data['total_profit']}';
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
    */
  }
}
