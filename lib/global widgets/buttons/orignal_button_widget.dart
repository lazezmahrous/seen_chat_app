import 'package:flutter/material.dart';
import 'package:seen/constanc.dart';

class OrignalButtonWidget extends StatelessWidget {
  const OrignalButtonWidget(
      {super.key, required this.onPressed, required this.text});
  final VoidCallback? onPressed;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Constanc.kOrignalColor,
            Constanc.kSecondColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(40),
        ),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            fixedSize: WidgetStateProperty.all(
              const Size(10, 45),
            ),
            shape: WidgetStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(17),
                ),
              ),
            )),
        onPressed: onPressed,
        child: Text(text!),
      ),
    );
  }
}
