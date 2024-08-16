import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  CardWidget({super.key, required this.child, required this.text});
  Widget? child;
  String? text;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .6,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text!,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            child!,
          ],
        ),
      ),
    );
  }
}
