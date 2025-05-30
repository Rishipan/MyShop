import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StockTile extends StatefulWidget {
  final String stockName;
  final int unitsAvailable;
  final double sellPrice;
  final Function()? onTap;
  const StockTile({
    super.key,
    required this.stockName,
    required this.sellPrice,
    required this.unitsAvailable,
    required this.onTap,
  });

  @override
  State<StockTile> createState() => _StockTileState();
}

class _StockTileState extends State<StockTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, left: 4, top: 4),
      child: Card(
        color: Colors.pink.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: ListTile(
          title: Text(
            widget.stockName,
            style: TextStyle(
              color: Colors.yellow,
              // fontSize: 20,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          subtitle: Text(
            'Units Available: ${widget.unitsAvailable}',
            style: TextStyle(
              // fontSize: 12,
              color: Colors.grey.shade100,
              fontFamily: GoogleFonts.roboto().fontFamily,
            ),
          ),
          trailing: Text(
            '₹ ${widget.sellPrice.toStringAsFixed(2)}',
            style: TextStyle(
              // fontSize: 20,
              color: Colors.white,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: widget.onTap,
        ),
      ),
    );
    // return Container(
    //   height: 80,
    //   margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
    //   decoration: BoxDecoration(
    //     color: Colors.green,
    //     borderRadius: BorderRadius.circular(8.0),
    //   ),
    //   child: Padding(
    //     padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
    //     child: Row(
    //       children: [
    //         Expanded(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               const Text(
    //                 'Limca',
    //                 style: TextStyle(
    //                   fontSize: 18,
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.white,
    //                 ),
    //               ),
    //               Text(
    //                 '1234567890',
    //                 style: TextStyle(
    //                   fontSize: 14,
    //                   color: Colors.white.withOpacity(0.8),
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 4,
    //               ),
    //               const Text(
    //                 'Units Available: 200',
    //                 style: TextStyle(
    //                   fontSize: 14,
    //                   color: Colors.yellow,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         const Padding(
    //           padding: EdgeInsets.only(right: 16, bottom: 16),
    //           child: Text(
    //             '₹ 100',
    //             style: TextStyle(
    //               fontSize: 20,
    //               fontWeight: FontWeight.bold,
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
