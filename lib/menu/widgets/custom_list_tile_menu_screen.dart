import 'package:chatbot/core/common_ui/custom_text.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final Color titleColor;
  final IconData leadingIcon;
  final Function() onTap;
  CustomListTile({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.onTap,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: CustomText(
        text: title,
        textColor: titleColor,
        isBold: true,
      ),
      leading: Icon(
        leadingIcon,
        color: titleColor,
      ),
      onTap: onTap,
    );
  }
}
