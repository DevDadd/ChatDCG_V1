import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// Label turns light blue while its TextField has focus
final _labelStyle = WidgetStateTextStyle.resolveWith(
  (states) => GoogleFonts.inter(
    color: states.contains(WidgetState.focused)
        ? Colors.lightBlue
        : Colors.grey,
  ),
);

// Tapping anywhere outside a TextField drops its focus and hides the keyboard
void _unfocus(PointerDownEvent _) =>
    FocusManager.instance.primaryFocus?.unfocus();

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x1C1C1D),
      appBar: AppBar(
        backgroundColor: Color(0x1C1C1D),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Your username and password",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Please enter your username and password\nto log in.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 24.h),
            TextField(
              cursorColor: Colors.lightBlue,
              onTapOutside: _unfocus,
              decoration: InputDecoration(
                labelText: "Username",
                labelStyle: _labelStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            TextField(
              cursorColor: Colors.lightBlue,
              onTapOutside: _unfocus,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: _labelStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              obscureText: true,
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          fixedSize: Size.square(56.r),
          padding: EdgeInsets.zero,
        ),
        child: Icon(Icons.arrow_forward, size: 24.r),
      ),
    );
  }
}
