import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenova/constants/colors.dart';
import 'package:zenova/constants/image_strings.dart';
import 'package:zenova/constants/sizes.dart';
import 'package:zenova/helper/helper_functions.dart';
import 'package:zenova/pages/habit_track/bloc/habit_track_page_bloc.dart';
import 'package:zenova/popups/fullscreen_loaders.dart';
import 'package:zenova/utils/appbar.dart';
import 'package:zenova/utils/e_circular_icon.dart';

class HabitTrack extends StatefulWidget {
  const HabitTrack({super.key});

  @override
  State<HabitTrack> createState() => _HabitTrackState();
}

class _HabitTrackState extends State<HabitTrack> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HabitTrackPageBloc habitTrackPageBloc = HabitTrackPageBloc();

  @override
  void initState() {
    super.initState();
    habitTrackPageBloc.add(HabitTrackPageInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return BlocConsumer<HabitTrackPageBloc, HabitTrackPageState>(
      bloc: habitTrackPageBloc,
      listenWhen: (previous, current) => current is HabitTrackPageActionState,
      buildWhen: (previous, current) => current is! HabitTrackPageActionState,
      listener: (context, state) {
        if (state is HabitTrackPageLogoutPressedState) {
          showDialog<void>(
            context: context,
            barrierDismissible:
                false, // user must tap button to close the dialog
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 24.0.sp,
                      fontWeight: FontWeight.w600,
                      color: dark ? EColors.white : Colors.black,
                    ),
                  ),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                        'Are you sure you want to logout?',
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w500,
                          color: dark ? EColors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          child: Text(
                            'Logout',
                            style: Theme.of(context).textTheme.bodySmall!.apply(
                                color: dark ? EColors.white : Colors.black),
                          ),
                          onPressed: () async {
                            EFullScreenLoader.openLoadingDialog(
                                'Loading...', context);
                            context.go('/');
                          },
                        ),
                      ),
                      SizedBox(
                        height: ESizes.sm.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.bodySmall!.apply(
                                color: dark ? Colors.black : EColors.white),
                          ),
                          onPressed: () {
                            context.pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HabitTrackPageLoadingState:
            return Scaffold(
              key: _scaffoldKey,
              appBar: EAppBar(
                title: Text(
                  'Habit Track',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                leadingIcon: Icons.menu_rounded,
                leadingOnPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              drawer: _buildDrawer(context, habitTrackPageBloc),
              body: Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 24.0.sp,
                    color: dark ? EColors.white : Colors.black,
                  ),
                ),
              ),
            );

          case HabitTrackPageLoadedState:
            return Scaffold(
              key: _scaffoldKey,
              appBar: EAppBar(
                title: Text(
                  'Habit Track',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                leadingIcon: Icons.menu_rounded,
                leadingOnPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              drawer: _buildDrawer(context, habitTrackPageBloc),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'You have pushed the button this many times:',
                    ),
                    Text(
                      '0',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            );

           case HabitTrackPageErrorState:
            return Scaffold(
              key: _scaffoldKey,
              appBar: EAppBar(
                title: Text(
                  'Habit Track',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                leadingIcon: Icons.menu_rounded,
                leadingOnPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              drawer: _buildDrawer(context, habitTrackPageBloc),
              body: Center(
                child: Text(
                  'Error loading data',
                  style: TextStyle(
                    fontSize: 24.0.sp,
                    color: dark ? EColors.white : Colors.black,
                  ),
                ),
              ),
            );

          default:
            return Scaffold(
              key: _scaffoldKey,
              appBar: EAppBar(
                title: Text(
                  'Habit Track',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                leadingIcon: Icons.menu_rounded,
                leadingOnPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              drawer: _buildDrawer(context, habitTrackPageBloc),
              body: Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 24.0.sp,
                    color: dark ? EColors.white : Colors.black,
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}

Drawer _buildDrawer(
    BuildContext context, HabitTrackPageBloc habitTrackPageBloc) {
  final dark = EHelperFunctions.isDarkMode(context);
  List<Map<String, dynamic>> drawerItems = [
    {
      'icon': Icons.account_circle_rounded,
      'title': 'Profile',
      'route': '/noti',
    },
    {
      'icon': Icons.settings_rounded,
      'title': 'Settings',
      'route': '/banner',
    },
    {
      'icon': Icons.logout,
      'title': 'Logout',
    },
  ];

  Widget buildListTile(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0.h),
      child: ListTile(
        leading: ECircularIcon(
          height: 44.h,
          width: 44.w,
          icon: item['icon'],
          size: 28.r,
          color: dark ? EColors.white : Colors.black,
          backgroundColor: EColors.primaryColor.withValues(alpha: 0.7),
        ),
        title: Text(
          item['title'],
          style: TextStyle(
            fontSize: 15.0.sp,
            fontWeight: FontWeight.w600,
            color: dark ? EColors.white : Colors.black,
          ),
        ),
        onTap: () {
          if (item['title'] == 'Logout') {
            habitTrackPageBloc.add(HabitTrackPageLogoutPressedEvent());
          } else {
            // Navigate normally for other items
            habitTrackPageBloc.add(HabitTrackPageListTileOnPressedEvent(
              context: context,
              route: item['route'],
            ));
          }
        },
      ),
    );
  }

  return Drawer(
    backgroundColor: dark ? Colors.black : EColors.white,
    width: 0.68.sw,
    elevation: 10,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20.r),
      ),
    ),
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        /// Branding
        DrawerHeader(
          decoration: BoxDecoration(color: EColors.primaryColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(EImages.appLogo, height: 68.h, width: 68.h),
              SizedBox(height: 8.h),
              Text(
                'Zenova',
                style: TextStyle(
                  fontSize: 24.0.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                'Unlock Your Potential.',
                style: TextStyle(
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: GoogleFonts.unna().fontFamily,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ESizes.xs.h),

        /// Drawer Items
        ...drawerItems.map(buildListTile),
      ],
    ),
  );
}
