import 'package:chatbot/core/constants/image_path_constants.dart';
import 'package:chatbot/core/utils/firebase_trimmed_errormsg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Future<dynamic> otpErrorBottomSheet(
    {required BuildContext context, required String errorMsg}) {
  return showModalBottomSheet(
      isScrollControlled: true,
      elevation: 1,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(color: Colors.grey, width: 96, height: 4),
                const SizedBox(height: 29),
                SvgPicture.asset(
                  ImagePaths.sendFailIcon,
                ),
                const SizedBox(height: 18),
                const Text(
                  "Failed!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  getTrimmedFirebaseMsg(errorMsg),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 29),
              ],
            ),
          ),
        );
      });
}
