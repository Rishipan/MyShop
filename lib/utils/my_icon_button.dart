import 'package:flutter/material.dart';

class MyIconButton extends StatefulWidget {
  final Icon icon;
  final String text;
  final Function()? onTap;
  const MyIconButton(
      {super.key, required this.icon, required this.text, required this.onTap});

  @override
  State<MyIconButton> createState() => _MyIconButtonState();
}

class _MyIconButtonState extends State<MyIconButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon.icon,
            color: Colors.white,
          ),
          Text(widget.text,
              style: const TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }
}
