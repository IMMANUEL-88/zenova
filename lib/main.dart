import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zenova/routes.dart';
import 'package:zenova/theme/theme.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => ScreenUtilInit(
        designSize: const Size(392.72, 856.72),
        minTextAdapt: true,
        builder: (_, child) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: lightMode,
      darkTheme: darkMode,
      routerConfig: AppRoutes.createRouter(),
    );
  }
}
