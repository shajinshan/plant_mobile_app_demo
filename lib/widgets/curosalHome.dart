import 'package:flutter/material.dart';

class ImageCurosal extends StatelessWidget {
  final String? imgPath;
  const ImageCurosal({super.key,this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imgPath!,
      fit: BoxFit.cover,
    );
  }
}
