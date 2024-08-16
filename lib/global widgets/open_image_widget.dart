import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

class OpenImageWidget extends StatelessWidget {
  const OpenImageWidget({super.key , required this.imageUrl , required this.child});

  final String imageUrl;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showImageViewer(context, Image.network(imageUrl).image, onViewerDismissed: () {
          print("dismissed");
        });
      },

      child:child ,
    );
  }
}
