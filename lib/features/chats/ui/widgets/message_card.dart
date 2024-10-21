import 'package:booking_clinics_doctor/core/constant/extension.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constant/const_color.dart';
class MessageTile extends StatelessWidget {
  final String content;
  final bool isMe;

  const MessageTile({
    super.key,
    required this.content,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        // constraints: BoxConstraints(maxWidth: 75.w),
        margin: EdgeInsets.symmetric(vertical: 0.75.h, horizontal: 6.w),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isMe
              ? ConstColor.primary.color
              : isDark
                  ? ConstColor.iconDark.color
                  : ConstColor.secondary.color,
          borderRadius: BorderRadius.only(
            topLeft: isMe ? Radius.circular(4.w) : Radius.circular(0.w),
            topRight: !isMe ? Radius.circular(4.w) : const Radius.circular(0),
            bottomLeft: Radius.circular(4.w),
            bottomRight: Radius.circular(4.w),
          ),
        ),
        child: Text(
          content,
          style: TextStyle(
            color: isMe
                ? ConstColor.dark.color
                : isDark
                    ? ConstColor.secondary.color
                    : ConstColor.dark.color,
          ),
        ),
      ),
    );
  }
}