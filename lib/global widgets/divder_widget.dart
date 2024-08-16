import 'package:flutter/material.dart';
import 'package:seen/constanc.dart';

class DivderWidget extends StatelessWidget {
  const DivderWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: Divider(
        color: Constanc.kColorGray,
      ),
    );
  }
}
