import 'package:booking_clinics_doctor/core/constant/extension.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constant/const_color.dart';

class ChatCard extends StatelessWidget {
  final String chatPartnerName;
  final String chatPartnerId;
  final String lastMessage;
  final String lastMessageTime;
  final String chatId;
  final VoidCallback onTap;

  const ChatCard({
    super.key,
    required this.chatPartnerName,
    required this.chatPartnerId,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.chatId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(4.w),
      color: MyColors.primary,
      child: InkWell(
        borderRadius: BorderRadius.circular(4.w),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatPartnerName,
                style: context.semi16!.copyWith(color: Colors.black),
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      lastMessage,
                      style: context.bold14!.copyWith(color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    lastMessageTime,
                    style: context.regular14!.copyWith(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
