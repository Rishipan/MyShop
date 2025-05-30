// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String labelText;
  final bool obscureText;
  final textinputtype;
  const MyTextField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.obscureText,
      required this.textinputtype});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        // autofocus: true,
        keyboardType: textinputtype,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
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
      ),
    );
  }
}
