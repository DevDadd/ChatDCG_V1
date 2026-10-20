import 'dart:convert';
import 'dart:developer';

import 'package:chatdcg_demo/presentation/cubit/authen_cubit.dart';
import 'package:chatdcg_demo/presentation/cubit/authen_state.dart';
import 'package:chatdcg_demo/presentation/widget/message_bubble_widget.dart';
import 'package:chatdcg_demo/presentation/widget/typing_bubble_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  ChatPage({
    super.key,
    required this.id,
    required this.isOnline,
    required this.userName,
  });
  final String userName;
  final int id;
  final bool isOnline;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final AuthenCubit _cubit = context.read<AuthenCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getHistory(widget.id).then((_) {
      log(jsonEncode(_cubit.state.history), name: 'ChatPage');
      // Comes with the history even when it is empty (new conversation)
      final conversationId = _cubit.state.history?.conversationId;
      if (mounted && conversationId != null) {
        _cubit.startMessageStream(conversationId);
      }
    });
  }

  @override
  void dispose() {
    _cubit.stopMessageStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        leadingWidth: 100.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Row(
            children: [
              SizedBox(
                height: 13.h,
                width: 13.h,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset("assets/arrow_back.svg"),
                ),
              ),
              SizedBox(width: 7.w),
              Text(
                "Chats",
                style: GoogleFonts.inter(fontSize: 17, color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: Container(
                height: 37.h,
                width: 37.h,
                color: Colors.lightBlue,
                child: Image.asset("assets/dcg_avatar.png", fit: BoxFit.cover),
              ),
            ),
          ),
        ],
        centerTitle: true,
        title: Column(
          children: [
            Text(
              widget.userName,
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            BlocSelector<AuthenCubit, AuthenState, bool>(
              selector: (state) {
                final users = state.userStatus?.users ?? [];
                final user = users.where((u) => u.userId == widget.id);
                return user.isEmpty
                    ? widget.isOnline
                    : user.first.isOnline ?? false;
              },
              builder: (context, isOnline) => Text(
                isOnline ? "Online" : "Offline",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isOnline ? Colors.lightBlue : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/background_chat.jpg", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BlocBuilder<AuthenCubit, AuthenState>(
              builder: (context, state) {
                if (state.isHistoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = state.history?.messages ?? [];
                // reverse: true, so index 0 is the bottom of the chat
                final typing = state.isOtherTyping ? 1 : 0;
                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.only(
                    left: 8.w,
                    right: 8.w,
                    top: 8.h,
                    bottom: 58.h + MediaQuery.of(context).padding.bottom,
                  ),
                  itemCount: messages.length + typing,
                  itemBuilder: (context, index) {
                    if (index < typing) return const TypingBubbleWidget();
                    final message =
                        messages[messages.length - 1 - (index - typing)];
                    return MessageBubbleWidget(
                      message: message,
                      isMine: message.senderId != widget.id,
                    );
                  },
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: const Color(0xFF1C1C1E),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: SizedBox(
                    height: 50.h,
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/attatch.svg"),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Container(
                            height: 33.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: Colors.black,
                              border: Border.all(color: Color(0xFF3A3A3C)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Focus(
                                    onFocusChange: (hasFocus) {
                                      if (!hasFocus) {
                                        context
                                            .read<AuthenCubit>()
                                            .stopTyping();
                                      }
                                    },
                                    child: TextField(
                                      onChanged: (value) {
                                        context
                                            .read<AuthenCubit>()
                                            .onChatTextChange();
                                      },
                                      textInputAction: TextInputAction.send,
                                      onEditingComplete: () => context
                                          .read<AuthenCubit>()
                                          .sendMessage(),
                                      controller: context
                                          .read<AuthenCubit>()
                                          .chatController,
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                      cursorColor: Colors.white,
                                      decoration: InputDecoration(
                                        hintText: "Messages",
                                        hintStyle: GoogleFonts.inter(
                                          fontSize: 15,
                                          color: const Color(0xFF8E8E93),
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SvgPicture.asset("assets/sticker.svg"),
                                SizedBox(width: 8.w),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        SvgPicture.asset("assets/record.svg"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
