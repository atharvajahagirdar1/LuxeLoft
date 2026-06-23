import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  final double size;
  const CustomLogo({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(Icons.change_history, color: const Color(0xFF1497AD), size: size * 1.5),
        Text(
          'uxeLoft',
          style: TextStyle(
            color: const Color(0xFFF99D1C),
            fontWeight: FontWeight.bold,
            fontSize: size,
          ),
        ),
      ],
    );
  }
}
