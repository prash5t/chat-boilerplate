import 'package:chatbot/core/constants/image_path_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ArrowLeftSVGIcon extends StatelessWidget {
  const ArrowLeftSVGIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(ImagePaths.arrowLeftSVG,
        width: 24.w,
        height: 24.w,
        color: Theme.of(context).colorScheme.primaryContainer);
  }
}
