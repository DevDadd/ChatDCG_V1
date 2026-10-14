import 'package:chatdcg_demo/presentation/pages/home_page.dart';
import 'package:chatdcg_demo/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'di.dart';

void main() {
  setupDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // designSize is the frame size of the Figma/mockup the UI is drawn from
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) =>
          MaterialApp(debugShowCheckedModeBanner: false, home: child),
      child: const HomePage(),
    );
  }
}
