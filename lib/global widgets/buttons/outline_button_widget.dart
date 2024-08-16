import 'package:flutter/material.dart';
import 'package:seen/constanc.dart';

class OutlineButtonWidget extends StatelessWidget {
  const OutlineButtonWidget(
      {super.key, required this.onPressed, required this.text});

  final VoidCallback? onPressed;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          side: const WidgetStatePropertyAll(BorderSide(width: 0.5)),
          backgroundColor: WidgetStateProperty.all(null),
          foregroundColor: WidgetStateProperty.all(Constanc.kSecondColor),
          fixedSize: WidgetStateProperty.all(
            const Size(10, 45),
          ),
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(40),
              ),
            ),
          )),
      onPressed: onPressed,
      child: Text(text!),
    );
  }
}
