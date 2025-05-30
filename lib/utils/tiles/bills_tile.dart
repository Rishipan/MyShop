import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BillTile extends StatefulWidget {
  final double amount;
  final double profit;
  final String description;

  const BillTile({
    super.key,
    required this.amount,
    required this.profit,
    required this.description,
  });

  @override
  State<BillTile> createState() => _BillTileState();
}

class _BillTileState extends State<BillTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, left: 4, top: 4),
      child: Card(
        color: Colors.pink.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: ListTile(
            title: Text(
              'Amount: ₹ ${widget.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.yellow,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              widget.description,
              style: TextStyle(
                color: Colors.grey.shade100,
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
            ),
            trailing: Text(
              '+₹ ${widget.profit.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white,
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
