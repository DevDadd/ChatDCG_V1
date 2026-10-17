import 'package:chatdcg_demo/data/models/message_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageBubbleWidget extends StatelessWidget {
  const MessageBubbleWidget({
    super.key,
    required this.message,
    required this.isMine,
  });

  final Message message;

  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final time = message.timestamp;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.symmetric(vertical: 3.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isMine ? Color(0xFF313131) : const Color(0xFF262628),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          // Time sits on the last line when the text wraps
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                message.content ?? '',
                style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
              ),
            ),
            if (time != null) ...[
              SizedBox(width: 6.w),
              Text(
                '${time.hour.toString().padLeft(2, '0')}:'
                '${time.minute.toString().padLeft(2, '0')}',
                style: GoogleFonts.inter(fontSize: 11, color: Colors.white60),
              ),
            ],
            // Written offline, waiting for SyncMessages
            if (message.isOffline) ...[
              SizedBox(width: 4.w),
              Icon(Icons.schedule, size: 12.sp, color: Colors.white60),
            ],
          ],
        ),
      ),
    );
  }
}
