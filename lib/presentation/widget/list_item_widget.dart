import 'package:chatdcg_demo/presentation/widget/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.noti,
    required this.time,
    this.avatarUrl,
  });

  final String name;
  final String? avatarUrl;
  final String lastMessage;
  final String time;
  final int noti;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76.h,
      color: Colors.transparent,
      child: Row(
        children: [
          AvatarWidget(url: avatarUrl, size: 60.r),
          SizedBox(width: 12.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
              ),
              Text(
                "previous messages",
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(height: 4.h),
              Container(
                width: 20.r,
                height: 20.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF636366),
                ),
                child: Center(
                  child: Text(
                    noti.toString(),
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
