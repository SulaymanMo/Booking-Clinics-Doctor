import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import '../../../core/common/input.dart';
import '../cubit/chat_details_cubit.dart';
import '../cubit/chat_details_state.dart';
import 'widgets/message_card.dart';

class ChatDetailScreen extends StatelessWidget {
  final String chatId;
  final String chatPartnerName;
  final String chatPartnerId;

  final TextEditingController _messageController = TextEditingController();

  ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.chatPartnerName,
    required this.chatPartnerId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatDetailCubit(FirebaseFirestore.instance, chatId)
        ..listenToMessages(),
      child: Scaffold(
        appBar: AppBar(title: Text(chatPartnerName)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Expanded(child: _buildMessagesList()),
              _buildMessageInput(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return BlocBuilder<ChatDetailCubit, ChatDetailState>(
      builder: (context, state) {
        if (state is ChatDetailLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ChatDetailError) {
          return Center(child: Text(state.error));
        }
        if (state is ChatDetailLoaded) {
          if (state.messages.isEmpty) {
            return const Center(child: Text('No messages yet'));
          }

          return ListView(
            reverse: true,
            children: state.messages.map((messageData) {
              String content = messageData['content'];
              String senderId = messageData['senderId'];
              bool isMe = senderId == FirebaseAuth.instance.currentUser!.uid;

              return MessageTile(content: content, isMe: isMe);
            }).toList(),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 6,
            child: Input(
              hint: "Type a message...",
              controller: _messageController,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: IconButton(
              icon: const Icon(Iconsax.send_1),
              onPressed: () {
                String message = _messageController.text;
                String userId = FirebaseAuth.instance.currentUser!.uid;
                _messageController.clear();

                // Send message using Cubit
                context.read<ChatDetailCubit>().sendMessage(message, userId);
              },
            ),
          ),
        ],
      ),
    );
  }
}
