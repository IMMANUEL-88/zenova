import 'package:go_router/go_router.dart';
import 'package:zenova/navigation.dart';
import 'package:zenova/pages/habit_track/ui/habit_track.dart';

class AppRoutes {
  static GoRouter createRouter() {
    return GoRouter(
      // initialLocation:
      //     prefs.getBool('login') ?? false ? '/home' : '/onBoarding',
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Navigation(),
        ),
        GoRoute(
          path: '/habit',
          builder: (context, state) => const HabitTrack(),
        ),

        // GoRoute(
        //   path: '/home',
        //   builder: (context, state) => const Home(),
        // ),
        // GoRoute(
        //   path: '/onBoarding',
        //   builder: (context, state) => const OnBoardingScreen(),
        // ),
        // GoRoute(
        //   path: '/cartPage',
        //   builder: (context, state) => const CartScreen(),
        // ),
        // GoRoute(
        //   path: '/address',
        //   builder: (context, state) => const UserAddressScreen(),
        // );
      ],
    );
  }
}
