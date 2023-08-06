import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

InputDecoration phoneNumberFieldDecorator(
    {required val, double vertialPadding = 0}) {
  return InputDecoration(
      contentPadding:
          EdgeInsets.symmetric(horizontal: 16.w, vertical: vertialPadding),
      hintText: '$val',
      hintStyle: const TextStyle(color: Colors.grey),
      border: outlineBorder(),
      focusedBorder: outlineBorder(),
      enabledBorder: outlineBorder());
}

OutlineInputBorder outlineBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.r)),
      borderSide: BorderSide(color: (Colors.grey[300])!));
}
