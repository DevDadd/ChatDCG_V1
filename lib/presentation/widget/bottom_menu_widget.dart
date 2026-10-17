import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum BottomMenuTab { contacts, calls, chats, settings }

/// iOS-style tab bar: Contacts, Calls, Chats (with unread badge), Settings
/// (with the user's avatar).
class BottomMenuWidget extends StatelessWidget {
  const BottomMenuWidget({
    super.key,
    required this.current,
    this.onTap,
    this.chatBadge = 0,
  });

  final BottomMenuTab current;
  final ValueChanged<BottomMenuTab>? onTap;

  // Hidden when 0
  final int chatBadge;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1C1C1E),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56.h,
          child: Row(
            children: [
              _item(
                BottomMenuTab.contacts,
                'Contacts',
                (color) => Icon(Icons.account_circle, size: 30.r, color: color),
              ),
              _item(
                BottomMenuTab.calls,
                'Calls',
                (color) => Icon(Icons.phone, size: 28.r, color: color),
              ),
              _item(
                BottomMenuTab.chats,
                'Chats',
                (color) => _ChatIcon(color: color, badge: chatBadge),
              ),
              _item(
                BottomMenuTab.settings,
                'Settings',
                (_) => ClipOval(
                  child: Image.asset(
                    'assets/dcg_avatar.png',
                    width: 28.r,
                    height: 28.r,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
    BottomMenuTab tab,
    String label,
    Widget Function(Color color) icon,
  ) {
    final color = tab == current ? Colors.white : const Color(0xFF8E8E93);
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap?.call(tab),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30.r, child: Center(child: icon(color))),
            SizedBox(height: 4.h),
            Text(label, style: GoogleFonts.inter(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }
}

class _ChatIcon extends StatelessWidget {
  const _ChatIcon({required this.color, required this.badge});

  final Color color;
  final int badge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(Icons.forum, size: 28.r, color: color),
        if (badge > 0)
          Positioned(
            top: -4.r,
            right: -8.r,
            child: Container(
              constraints: BoxConstraints(minWidth: 18.r),
              height: 18.r,
              padding: EdgeInsets.symmetric(horizontal: 4.r),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9.r),
                // Ring in the bar color so the badge stands off the icon
                border: Border.all(color: const Color(0xFF1C1C1E), width: 1.5),
              ),
              child: Text(
                badge > 99 ? '99+' : '$badge',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
