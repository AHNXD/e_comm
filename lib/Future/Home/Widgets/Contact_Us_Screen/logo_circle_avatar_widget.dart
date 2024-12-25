import 'package:e_comm/Utils/images.dart';
import 'package:flutter/material.dart';

class LogoCircleAvatarWidget extends StatelessWidget {
  const LogoCircleAvatarWidget({
    super.key,
    required this.top,
    required this.bottom,
  });
  final double top;
  final double bottom;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Image.asset(AppImagesAssets.logoNoBg),
    );
  }
}
