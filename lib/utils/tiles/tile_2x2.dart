import 'package:flutter/material.dart';

class Tile2x2 extends StatelessWidget {
  const Tile2x2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
      child: Card(
        color: Colors.green.shade400,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: const [
                  Text(
                    'Today\'s most profitable item',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.yellow,
                    ),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              const SizedBox(height: 8.0),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: const [
              //         Text(
              //           'Product name',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 16.0,
              //           ),
              //           textAlign: TextAlign.center,
              //         ),
              //         Text(
              //           'Product category',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 16.0,
              //           ),
              //           textAlign: TextAlign.center,
              //         ),
              //         Text(
              //           'Today\'s profit',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 16.0,
              //           ),
              //           textAlign: TextAlign.center,
              //         ),
              //       ],
              //     ),
              //     Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: const [
              //         Text(
              //           'Product name',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 16.0,
              //           ),
              //           textAlign: TextAlign.center,
              //         ),
              //         Text(
              //           'Product category',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 16.0,
              //           ),
              //           textAlign: TextAlign.center,
              //         ),
              //         Text(
              //           'Today\'s profit',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 16.0,
              //           ),
              //           textAlign: TextAlign.center,
              //         ),
              //       ],
              //     ),
              //     Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: const [
              //         Text(
              //           'Product name',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 16.0,
              //           ),
              //           textAlign: TextAlign.center,
              //         ),
              //         Text(
              //           'Product cate..',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 16.0,
              //           ),
              //           textAlign: TextAlign.center,
              //         ),
              //         Text(
              //           'Today\'s profit',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 16.0,
              //           ),
              //           textAlign: TextAlign.center,
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
