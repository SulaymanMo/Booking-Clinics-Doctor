import 'package:booking_clinics_doctor/core/constant/images_path.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImage extends StatelessWidget {
  final String? image;
  final Widget? errorWidget;
  final double? borderRadius;
  final double? width, height;
  final String? errorImage;
  const CustomImage({
    super.key,
    this.width,
    this.height,
    this.errorImage,
    this.errorWidget,
    this.borderRadius,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 50.w),
      child: CachedNetworkImage(
        imageUrl: image ?? "",
        width: width ?? 35.w,
        height: height ?? 35.w,
        fit: BoxFit.cover,
        placeholder: (_, url) => SizedBox(
          width: width ?? 35.w,
          height: height ?? 35.w,
          // width: double.infinity,
        ),
        errorWidget: (_, url, error) =>
            errorWidget ??
            Image.asset(
              errorImage ?? MyImages.doctorAvatar,
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
        errorListener: null,
      ),
    );
  }
}
