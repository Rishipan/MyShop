// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MyMethods {
  checkConnectivity(BuildContext context) async {
    var connectionResult = await Connectivity().checkConnectivity();

    if (connectionResult != ConnectivityResult.mobile &&
        connectionResult != ConnectivityResult.wifi) {
      if (!context.mounted) {
        displaySnackBar('Internet not Available', Colors.red, context);
      }
    }
  }

  displaySnackBar(String message, Color color, BuildContext context) {
    var snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
