import 'package:chatbot/conversations/data/models/persona_model.dart';
import 'package:chatbot/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvailabilityIconWidget extends StatelessWidget {
  final String status;
  final double widthHeight;
  const AvailabilityIconWidget(
      {super.key, required this.status, required this.widthHeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthHeight.w,
      height: widthHeight.h,
      child: status == PersonaModel.kKeyActive
          ? CircleAvatar(backgroundColor: AppColors.successColor)
          : status == PersonaModel.kKeyInactive
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(backgroundColor: Colors.black54),
                    CircleAvatar(
                      backgroundColor: Colors.white54,
                      radius: widthHeight / 3,
                    )
                  ],
                )
              : Icon(
                  Icons.notifications_off_outlined,
                  color: Colors.grey,
                  size: widthHeight * 1.5,
                ),
    );
  }
}

class OnlineStatusWidget extends StatelessWidget {
  const OnlineStatusWidget({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    bool isStatusActive = status == PersonaModel.kKeyActive;
    Color onlineStatusColor =
        isStatusActive ? AppColors.successColor : Colors.grey;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AvailabilityIconWidget(status: status, widthHeight: 8),
        SizedBox(width: 5.w),
        Text(
          isStatusActive ? "Online" : "Offline",
          style: TextStyle(
            fontSize: 17.sp,
            color: onlineStatusColor,
          ),
        )
      ],
    );
  }
}
