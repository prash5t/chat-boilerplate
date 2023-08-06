import 'package:flutter/material.dart';

class SizedBoxHeight50 extends StatelessWidget {
  const SizedBoxHeight50({super.key, required this.widget});

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 50, child: widget);
  }
}
