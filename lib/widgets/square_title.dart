import 'package:flutter/material.dart';

class SquareTitle extends StatelessWidget {
  final String pahtImage;
  final String text;
  final Function()? onTap;
  const SquareTitle({super.key, required this.pahtImage, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Image.asset(pahtImage, height: 36),
            const SizedBox(width: 3,),
            Text(text),
          ],
        ),
      ),
    );
  }
}
