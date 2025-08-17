import 'package:go_router/go_router.dart';
import 'package:zenova/navigation.dart';
import 'package:zenova/pages/analytics/ui/analytics.dart';
import 'package:zenova/pages/forgot_password/ui/forgot_password.dart';
import 'package:zenova/pages/habit_track/ui/habit_track.dart';
import 'package:zenova/pages/login/ui/login.dart';
import 'package:zenova/pages/login_verify/ui/login_verify.dart';
import 'package:zenova/pages/profile/ui/profile.dart';
import 'package:zenova/pages/settings/settings.dart';
import 'package:zenova/pages/signup/ui/signup.dart';
import 'package:zenova/pages/signup/ui/signup_verify_screen.dart';
import 'package:zenova/provider/theme_provider.dart';
import 'package:zenova/utils/local_storage/hive_storage_helper.dart';

class AppRoutes {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: HiveStorageHelper.isLoggedIn() ? '/home' : '/',
      refreshListenable: ThemeProvider(),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const Navigation(),
        ),
        GoRoute(
          path: '/habit',
          builder: (context, state) => const HabitTrack(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const Login(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignUpScreen(),
        ),

        GoRoute(
          path: '/analytics',
          builder: (context, state) => Analytics(),
        ),
        GoRoute(
          path: '/otp',
          builder: (context, state) {
            final email = state.extra as String;
            return LoginOtpVerificationPage(email: email);
          },
        ),
        GoRoute(
          path: '/resetPassword',
          builder: (context, state) {
            final email = state.extra as String;
            return ForgotPasswordOtpPage(email: email);
          },
        ),
        GoRoute(
          path: '/signUpVerifyOtp',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return SignupOtpPage(
              email: extra['email'],
              password: extra['password'],
              firstName: extra['firstName'],
              lastName: extra['lastName'],
            );
          },
        ),

        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),// 

        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),// 

        // GoRoute(
        //   path: '/analytics',
        //   builder: (context, state) => const UserAddressScreen(),
        // ),

      ],
    );
  }
}
