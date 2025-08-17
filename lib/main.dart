import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zenova/pages/analytics/repo/analytics_repo.dart';
import 'package:zenova/provider/theme_provider.dart';
import 'package:zenova/routes.dart';
import 'package:zenova/theme/theme.dart';
import 'package:zenova/utils/local_storage/hive_storage_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await HiveStorageHelper.initialize();

  // Check if user is logged in and fetch analytics
  if (HiveStorageHelper.isLoggedIn()) {
    final userId = HiveStorageHelper.getUserId();
    if (userId != null) {
      try {
        final analytics = await AnalyticsService.fetchAnalytics(userId);
        await HiveStorageHelper.saveAnalyticsData(analytics);
      } catch (e) {
        debugPrint('Error fetching analytics: $e');
      }
    }
  }

  // Wrap your app with the provider
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // This build method no longer listens to the provider.
    // It builds the constant parts of your app.
    return DevicePreview(
      enabled: false,
      builder: (context) => ScreenUtilInit(
        designSize: const Size(392.72, 856.72),
        minTextAdapt: true,
        builder: (_, child) => Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            if (themeProvider.isLoading) {
              return const MaterialApp(
                home:
                    Scaffold(body: Center(child: CircularProgressIndicator())),
              );
            }

            final router = AppRoutes.createRouter();
            return MaterialApp.router(
              key: ValueKey(themeProvider.themeMode),
              debugShowCheckedModeBanner: false,
              themeMode: themeProvider.themeMode,
              theme: lightMode,
              darkTheme: darkMode,
              routerConfig: router,
            );
          },
        ),
      ),
    );
  }
}
