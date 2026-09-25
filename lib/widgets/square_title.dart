import 'package:flutter/material.dart';

class SquareTitle extends StatelessWidget {
  final String pahtImage;
  final Function()? onTap;
  const SquareTitle({super.key, required this.pahtImage, required this.onTap});

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
        child: Image.asset(pahtImage, height: 36),
      ),
    );
  }
}
