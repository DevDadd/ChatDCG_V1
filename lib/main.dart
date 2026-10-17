import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatdcg_demo/presentation/cubit/authen_cubit.dart';
import 'package:chatdcg_demo/presentation/pages/splash_page.dart';
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
    return BlocProvider(
      create: (context) => AuthenCubit(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) =>
            MaterialApp(debugShowCheckedModeBanner: false, home: child),
        child: const SplashPage(),
      ),
    );
  }
}
