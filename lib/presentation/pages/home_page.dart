import 'dart:io';

import 'package:chatdcg_demo/presentation/cubit/authen_cubit.dart';
import 'package:chatdcg_demo/presentation/cubit/authen_state.dart';
import 'package:chatdcg_demo/presentation/pages/chat_page.dart';
import 'package:chatdcg_demo/presentation/pages/contacts_page.dart';
import 'package:chatdcg_demo/presentation/widget/liquid_button.dart';
import 'package:chatdcg_demo/presentation/widget/liquid_icon_button.dart';
import 'package:chatdcg_demo/presentation/widget/list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthenCubit>().getConversations();
  }

  void _openContacts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0x1C1C1E),
        title: Text(
          "Chats",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        // Wider on iOS so "Edit" fits beside the glass button's side padding
        leadingWidth: Platform.isIOS ? 88 : 72,
        leading: Platform.isIOS
            ? Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Center(
                  child: LiquidButton(
                    label: "Edit",
                    height: 36,
                    onPressed: _openContacts,
                  ),
                ),
              )
            : TextButton(
                onPressed: _openContacts,
                child: Text(
                  "Edit",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
        actions: [
          if (Platform.isIOS)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: LiquidIconButton(
                sfSymbol: "square.and.pencil",
                icon: Icons.edit_square,
                color: Colors.white,
                size: 36,
                onPressed: () {},
              ),
            )
          else
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/edit_icon.svg",
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                width: 20.w,
                height: 20.h,
              ),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.h),
        child: Column(
          children: [
            Container(
              height: 35.h,
              decoration: BoxDecoration(
                color: Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/search.svg"),
                  SizedBox(width: 5.w),
                  Text(
                    "Search",
                    style: GoogleFonts.inter(color: Colors.grey, fontSize: 17),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: BlocBuilder<AuthenCubit, AuthenState>(
                buildWhen: (previous, current) =>
                    previous.conversations != current.conversations ||
                    previous.userStatus != current.userStatus,
                builder: (context, state) {
                  final conversations =
                      state.conversations?.conversations ?? [];
                  return ListView.separated(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = conversations[index];
                      final otherUser = conversation.otherUser;
                      final otherUserId =
                          int.tryParse(otherUser?.id ?? '') ?? 0;
                      // ConversationInfo has no presence: look it up in GetUsersStatus
                      final isOnline =
                          state.userStatus?.users
                              ?.where((u) => u.userId == otherUserId)
                              .firstOrNull
                              ?.isOnline ??
                          false;
                      final createdAt = conversation.createdAt;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                id: otherUserId,
                                isOnline: isOnline,
                                userName: otherUser?.displayName ?? "",
                              ),
                            ),
                            // Chat may have created a new conversation: reload
                          ).then((_) {
                            if (context.mounted) {
                              context.read<AuthenCubit>().getConversations();
                            }
                          });
                        },
                        child: ListItemWidget(
                          name: otherUser?.displayName ?? "",
                          lastMessage: "",
                          noti: 0,
                          time: createdAt == null
                              ? ""
                              : "${createdAt.hour.toString().padLeft(2, '0')}:"
                                    "${createdAt.minute.toString().padLeft(2, '0')}",
                        ),
                      );
                    },
                    // Starts past the 60.r avatar so the line only spans the text area
                    separatorBuilder: (context, index) => Divider(
                      indent: 60.r + 12.w,
                      height: 1,
                      thickness: 0.2,
                      color: Colors.grey.shade800,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
