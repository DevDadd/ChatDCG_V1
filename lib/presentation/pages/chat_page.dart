import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

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
              "DaCoolGuy",
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Text(
              "last seen just now",
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/background_chat.jpg", fit: BoxFit.cover),
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
                                  child: TextField(
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
