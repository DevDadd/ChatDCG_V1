import 'package:chatdcg_demo/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  // Logo bay từ dưới đáy màn hình lên giữa, nảy nhẹ khi tới nơi
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 3),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.75, curve: Curves.elasticOut),
    ),
  );

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.3, curve: Curves.easeIn),
  );

  late final Animation<double> _scale = Tween<double>(begin: 0.6, end: 1)
      .animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0, 0.75, curve: Curves.easeOutBack),
        ),
      );

  @override
  void initState() {
    super.initState();
    _controller.forward().then((_) async {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, _, _) => const LoginPage(),
          transitionsBuilder: (_, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SlideTransition(
              position: _slide,
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  // Bo tròn để cắt bỏ nền trắng ở 4 góc ảnh
                  child: ClipOval(
                    child: Image.asset(
                      'assets/splash_logo.png',
                      width: 200.w,
                      height: 200.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
