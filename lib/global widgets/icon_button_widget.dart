// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:seen/constanc.dart';

class IconButtonWidget extends StatelessWidget {
  IconButtonWidget({super.key, required this.icon, required this.onPressed});
  Widget? icon;
  VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      child: Row(
        children: [
          IconButton(
            padding: const EdgeInsets.all(5),
            onPressed: onPressed,
            icon: icon!,
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Constanc.kColorblack),
              backgroundColor: WidgetStatePropertyAll(Constanc.kColorGray),
              shape: const WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
