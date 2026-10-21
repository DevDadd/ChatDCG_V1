import 'dart:io';

import 'package:chatdcg_demo/presentation/cubit/authen_cubit.dart';
import 'package:chatdcg_demo/presentation/cubit/authen_state.dart';
import 'package:chatdcg_demo/presentation/pages/chat_page.dart';
import 'package:chatdcg_demo/presentation/widget/liquid_button.dart';
import 'package:chatdcg_demo/presentation/widget/liquid_icon_button.dart';
import 'package:chatdcg_demo/presentation/widget/list_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthenCubit>().getUserStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0x1C1C1E),
        // Sort only exists as the iOS glass button; Android keeps the old
        // AppBar (no leading, so the back arrow shows when pushed from Edit)
        leading: Platform.isIOS
            ? Padding(
                padding: const EdgeInsets.only(left: 12),
                child: LiquidButton(
                  label: "Sort",
                  height: 36,
                  onPressed: () {},
                ),
              )
            : null,
        title: Text(
          "Contacts",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leadingWidth: Platform.isIOS ? 88 : 72,

        actions: [
          if (Platform.isIOS)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: LiquidIconButton(
                sfSymbol: "plus",
                icon: Icons.add,
                color: Colors.white,
                size: 36,
                onPressed: () {},
              ),
            )
          else
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/add.svg",
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
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AuthenCubit, AuthenState>(
          buildWhen: (previous, current) =>
              previous.userStatus != current.userStatus,
          builder: (context, state) {
            final users = state.userStatus?.users ?? [];
            return ListView.separated(
              // 2 fixed action rows above the users
              itemCount: users.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _ContactActionItem(
                    icon: Icons.location_on_outlined,
                    title: "Add People Nearby",
                    onTap: () {},
                  );
                }
                if (index == 1) {
                  return _ContactActionItem(
                    icon: Icons.person_add_alt_outlined,
                    title: "Invite Friends",
                    onTap: () {},
                  );
                }
                index -= 2;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          id: users[index].userId ?? 0,
                          isOnline: users[index].isOnline ?? false,
                          userName: users[index].displayName ?? "",
                          avatarUrl: users[index].avatarUrl,
                        ),
                      ),
                    ).then((_) {
                      if (context.mounted)
                        context.read<AuthenCubit>().getConversations();
                    });
                  },
                  child: ListUserWidget(
                    userName: users[index].displayName ?? "",
                    status: users[index].isOnline ?? false,
                    avatarUrl: users[index].avatarUrl,
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(
                // Avatar width + gap in ListUserWidget, so the line starts at the name
                indent: 40.h + 10.w,
                height: 1,
                thickness: 0.2,
                color: Colors.grey.shade800,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Icon + title row; same size as ListUserWidget so the dividers line up.
class _ContactActionItem extends StatelessWidget {
  const _ContactActionItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // Makes the empty space in the row tappable too
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 50.h,
        child: Row(
          children: [
            SizedBox(
              width: 40.h,
              child: Icon(icon, color: Colors.white, size: 26.r),
            ),
            SizedBox(width: 10.w),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
