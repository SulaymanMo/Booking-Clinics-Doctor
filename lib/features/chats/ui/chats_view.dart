import 'package:booking_clinics_doctor/core/common/skeleton.dart';
import 'package:booking_clinics_doctor/core/constant/const_color.dart';
import 'package:booking_clinics_doctor/core/constant/const_string.dart';
import 'package:booking_clinics_doctor/core/constant/extension.dart';
import 'package:booking_clinics_doctor/features/chats/ui/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../data/models/chat_model.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String currentUserId = auth.currentUser!.uid;

    return BlocProvider(
      create: (context) =>
          ChatCubit(FirebaseFirestore.instance, currentUserId)..listenToChats(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return ListView.separated(
                itemCount: 7,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                itemBuilder: (_, index) {
                  return Skeleton(width: double.infinity, height: 8.5.h);
                },
                separatorBuilder: (_, index) => SizedBox(height: 1.5.h),
              );
            }
            if (state is ChatError) {
              return Center(child: Text(state.error));
            }
            if (state is ChatLoaded) {
              if (state.chats.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.messages, size: 48.sp),
                      SizedBox(height: 2.h),
                      Text(
                        'No chats found',
                        style: context.medium16?.copyWith(
                          color: ConstColor.icon.color,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                child: ListView.separated(
                  separatorBuilder: (_, __) => SizedBox(height: 1.5.h),
                  itemCount: state.chats.length,
                  itemBuilder: (context, index) {
                    var chatData = state.chats[index];
                    String lastMessage = chatData['lastMessage'];
                    Timestamp lastMessageTime = chatData['lastMessageTime'];
                    List<dynamic> participants = chatData['participants'];

                    String chatPartnerId =
                        participants.firstWhere((id) => id != currentUserId);

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('doctors')
                          .doc(chatPartnerId)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(title: Text('Loading...'));
                        }

                        if (!userSnapshot.hasData ||
                            !userSnapshot.data!.exists) {
                          return const ListTile(title: Text('User not found'));
                        }

                        var userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        String chatPartnerName = userData['name'] ?? 'Unknown';

                        return ChatCard(
                          chatPartnerName: chatPartnerName,
                          chatPartnerId: chatPartnerId,
                          lastMessage: lastMessage,
                          lastMessageTime: _formatTimestamp(lastMessageTime),
                          chatId: chatData['chatId'],
                          onTap: () {
                            ChatModel chatModel = ChatModel(
                              chatId: chatData['chatId'],
                              chatPartnerName: chatPartnerName,
                              chatPartnerId: chatPartnerId,
                            );
                            context.nav.pushNamed(
                              Routes.chatDetailsRoute,
                              arguments: chatModel,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    var dateTime = timestamp.toDate();
    var formatter = DateFormat('h:mm a, d MMM');
    return formatter.format(dateTime);
  }
}
