import 'package:chatdcg_demo/presentation/widget/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListUserWidget extends StatelessWidget {
  const ListUserWidget({
    super.key,
    required this.userName,
    required this.status,
    this.avatarUrl,
  });
  final String userName;
  final String? avatarUrl;
  final bool status;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          AvatarWidget(url: avatarUrl, size: 40.h),
          SizedBox(width: 10.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                status ? "Online" : "Offline",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: status ? Colors.lightBlue : Colors.grey,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
