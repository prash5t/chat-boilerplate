import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbot/core/constants/app_colors.dart';
import 'package:chatbot/core/constants/image_path_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// for widget
class CachedImageWidget extends StatelessWidget {
  const CachedImageWidget({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => LinearProgressIndicator(
              color: AppColors.unCheckedColorLightTheme,
            ),
        errorWidget: (context, url, error) =>
            new SvgPicture.asset(ImagePaths.splashLogo));
  }
}

// for image provider
CachedNetworkImageProvider buildCachedImageProvider(String imageUrl) =>
    CachedNetworkImageProvider(imageUrl);
