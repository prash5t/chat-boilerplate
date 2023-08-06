import 'package:flutter/material.dart';

// as we need different font size of text,
//making a custom text widget to accept
//required properties from arguments
class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final bool isBold;
  final bool alignCenter;
  final Color? textColor;

  const CustomText(
      {super.key,
      required this.text,
      this.size = 16,
      this.isBold = false,
      this.alignCenter = false,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignCenter ? TextAlign.center : null,
      style: TextStyle(
          fontSize: size,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: textColor != null ? textColor : null),
    );
  }
}
