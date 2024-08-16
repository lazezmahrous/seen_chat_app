import 'package:flutter/material.dart';

class Kbutton extends StatefulWidget {
  Kbutton(
      {super.key,
      this.onPressed,
      this.text,
      this.backgroundColor,
      this.foregroundColor});
  VoidCallback? onPressed;
  String? text;
  Color? backgroundColor;
  Color? foregroundColor;
  @override
  State<Kbutton> createState() => _KbuttonState();
}

class _KbuttonState extends State<Kbutton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(widget.foregroundColor),
              backgroundColor: WidgetStatePropertyAll(widget.backgroundColor),
            ),
            onPressed: widget.onPressed,
            child: Text(widget.text!),
          ),
        ),
      ],
    );
  }
}
