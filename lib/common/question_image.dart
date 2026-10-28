import 'package:cached_network_image/cached_network_image.dart';
import 'package:drive_pass/resource/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Question illustration. Bundled assets render offline; http(s) URLs fall back to the network.
class QuestionImage extends StatelessWidget {
  final String path;

  const QuestionImage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    final Widget image = path.startsWith('http')
        ? CachedNetworkImage(
            imageUrl: path,
            width: double.infinity,
            fit: BoxFit.contain,
            placeholder: (_, __) => _frame(const CircularProgressIndicator(strokeWidth: 2)),
            errorWidget: (_, __, ___) => _broken(),
          )
        : Image.asset(
            path,
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _broken(),
          );
    return ClipRRect(borderRadius: BorderRadius.circular(12.r), child: image);
  }

  Widget _frame(Widget child) => Container(
        height: 160.h,
        width: double.infinity,
        color: AppColors.border,
        alignment: Alignment.center,
        child: child,
      );

  Widget _broken() => _frame(Icon(Icons.broken_image_outlined, size: 40.w, color: AppColors.textLight));
}
