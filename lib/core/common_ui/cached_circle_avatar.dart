import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbot/core/constants/image_path_constants.dart';
import 'package:flutter/material.dart';

class CachedCircleAvatar extends StatelessWidget {
  final String imageUrl;
  final double? radius;
  const CachedCircleAvatar({super.key, required this.imageUrl, this.radius});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        return CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: imageProvider,
          radius: radius ?? null,
        );
      },
      placeholder: (context, url) =>
          PlaceholderForCachedCircleAvatar(radius: radius),
      errorWidget: (context, url, error) {
        return PlaceholderForCachedCircleAvatar(radius: radius);
      },
    );
  }
}

class PlaceholderForCachedCircleAvatar extends StatelessWidget {
  const PlaceholderForCachedCircleAvatar({
    super.key,
    required this.radius,
  });

  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      backgroundImage: AssetImage(ImagePaths.defaultDP),
      radius: radius ?? null,
    );
  }
}
