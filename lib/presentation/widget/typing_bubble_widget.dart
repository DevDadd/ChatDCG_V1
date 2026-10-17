import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "The other person is typing" bubble: three dots bouncing in turn, styled
/// like the other person's message bubble.
class TypingBubbleWidget extends StatefulWidget {
  const TypingBubbleWidget({super.key});

  @override
  State<TypingBubbleWidget> createState() => _TypingBubbleWidgetState();
}

class _TypingBubbleWidgetState extends State<TypingBubbleWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 3.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFF262628),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) SizedBox(width: 4.w),
                _dot(i),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Each dot is a third of a cycle behind the previous one
  Widget _dot(int index) {
    final phase = (_controller.value - index / 3) % 1;
    final wave = sin(phase * 2 * pi).clamp(0.0, 1.0);
    return Transform.translate(
      offset: Offset(0, -3.h * wave),
      child: Container(
        width: 7.w,
        height: 7.w,
        decoration: BoxDecoration(
          color: Color.lerp(Colors.white38, Colors.white, wave),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
