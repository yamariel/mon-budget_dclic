import 'package:flutter/material.dart';

class SquareTitle extends StatelessWidget {
  final String pahtImage;
  const SquareTitle({super.key, required this.pahtImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200]
      ),
      child: Image.asset(pahtImage, height: 46,),
    );
  }

}