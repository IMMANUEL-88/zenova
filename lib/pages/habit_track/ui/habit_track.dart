import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zenova/constants/colors.dart';
import 'package:zenova/constants/image_strings.dart';
import 'package:zenova/constants/sizes.dart';
import 'package:zenova/helper/helper_functions.dart';
import 'package:zenova/pages/habit_track/bloc/habit_track_page_bloc.dart';
import 'package:zenova/popups/fullscreen_loaders.dart';
import 'package:zenova/popups/loaders.dart';
import 'package:zenova/utils/appbar.dart';
import 'package:zenova/utils/e_circular_icon.dart';
import 'package:zenova/utils/local_storage/hive_storage_helper.dart';

class HabitTrack extends StatefulWidget {
  const HabitTrack({super.key});

  @override
  State<HabitTrack> createState() => _HabitTrackState();
}

class _HabitTrackState extends State<HabitTrack> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _habitController = TextEditingController();
  List<Habit> habits = [];
  Map<DateTime, int> completedHabits = {};
  final HabitTrackPageBloc habitTrackPageBloc = HabitTrackPageBloc();

  @override
  void initState() {
    super.initState();
    habitTrackPageBloc.add(HabitTrackPageInitialEvent());
    habits = [
      Habit(name: 'Drink water', isCompleted: false),
      Habit(name: 'Exercise', isCompleted: false),
      Habit(name: 'Read', isCompleted: false),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _habitController.dispose();
  }

  void _addHabit() {
    final dark = EHelperFunctions.isDarkMode(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add New Habit',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: dark ? EColors.white : Colors.black,
            ),
          ),
          content: Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: EColors.primaryColor, // Your cursor color
                selectionColor: EColors.primaryColor
                    .withValues(alpha: 0.3), // Text selection color
                selectionHandleColor:
                    EColors.primaryColor, // Selection handle color
              ),
            ),
            child: TextField(
              controller: _habitController,
              style: TextStyle(
                color: dark ? EColors.white : Colors.black,
              ),
              decoration: InputDecoration(
                hintText: "Enter habit name",
                hintStyle: TextStyle(
                  color:
                      dark ? EColors.white.withValues(alpha: 0.5) : Colors.grey,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: dark ? EColors.white : Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _habitController.clear();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: EColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                minimumSize: Size(0.18.sw, 0.04.sh),
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              ),
              child: Text(
                'Add',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                if (_habitController.text.isNotEmpty) {
                  setState(() {
                    habits.add(
                        Habit(name: _habitController.text, isCompleted: false));
                    _habitController.clear();
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleHabit(int index) {
    setState(() {
      habits[index].isCompleted = !habits[index].isCompleted;

      // Update the completed habits count for today
      final today = DateTime.now();
      final dateKey = DateTime(today.year, today.month, today.day);

      if (habits[index].isCompleted) {
        completedHabits[dateKey] = (completedHabits[dateKey] ?? 0) + 1;
      } else {
        completedHabits[dateKey] = (completedHabits[dateKey] ?? 1) - 1;
        if (completedHabits[dateKey]! <= 0) {
          completedHabits.remove(dateKey);
        }
      }
    });
  }

  void _deleteHabit(int index) {
    setState(() {
      habits.removeAt(index);
    });
  }

  Color _getCellColor(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    final count = completedHabits[dateKey] ?? 0;

    if (count == 0) return Colors.transparent;

    // More habits completed = darker green
    final opacity = 0.2 + (0.8 * (count / habits.length).clamp(0.0, 1.0));
    return Color(0xFFA8C3A0).withValues(alpha: opacity);
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
                                'Logging Out...', context);
                            await HiveStorageHelper.clearAll();
                            EFullScreenLoader.stopLoading(context);
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
        // if(state is ){

        // }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case const (HabitTrackPageLoadingState):
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
                child: EAnimationLoaderWidget(
                    image: dark
                        ? EImages.darkLoadingAppLogo
                        : EImages.lightLoadingAppLogo,
                    text: "Loading..."),
              ),
            );

          case const (HabitTrackPageLoadedState):
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
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Habit Heat Map Calendar
                    Container(
                      padding: EdgeInsets.all(16),
                      child: TableCalendar(
                        firstDay:
                            // TODO; Change this to the actual first day of the user's habit tracking
                            DateTime.utc(2025, 3, 1), // User Downloaded date
                        lastDay: DateTime.now().add(Duration(days: 30)),
                        focusedDay: DateTime.now(),
                        calendarStyle: CalendarStyle(
                          weekendTextStyle: TextStyle(
                            color: dark ? Colors.red[200] : Colors.red,
                          ),
                          todayDecoration: BoxDecoration(
                            color: _getCellColor(
                                DateTime.now()), // Apply the color directly
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: EColors.primaryColor,
                              width: 1,
                            ),
                          ),
                          defaultTextStyle: TextStyle(
                            color: dark ? EColors.white : Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          todayTextStyle: TextStyle(
                            color: dark ? EColors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: dark ? EColors.white : Colors.black,
                          ),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: dark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          weekendStyle: TextStyle(
                            color: dark ? Colors.red[200] : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        weekendDays: [
                          DateTime.sunday,
                        ],

                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, events) {
                            // Remove the markerBuilder logic as it's no longer needed
                            return null;
                          },
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          // You can add functionality when a day is selected
                        },
                      ),
                    ),

                    // Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: ElevatedButton.icon(
                            onPressed: _addHabit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: EColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              minimumSize: Size(0.21.sw, 0.05.sh),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.h, horizontal: 10.w),
                            ),
                            label: Text(
                              'Add Habit',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            icon: Icon(
                              Icons.add,
                              size: 20.r,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Habit List with check Box
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: habits.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          key: Key(habits[index].name),
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            extentRatio: 0.35,
                            children: [
                              Container(
                                height: 100.h,
                                width: 60.w,
                                decoration: BoxDecoration(
                                  color: dark
                                      ? EColors.primaryColor
                                          .withValues(alpha: 0.1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.edit, size: 24.sp),
                                  color: dark ? EColors.white : Colors.black,
                                  onPressed: () =>
                                      _showEditDialog(context, index, dark),
                                ),
                              ),
                              SizedBox(width: 8.w), // Add gap between icons
                              Container(
                                height: 100.h,
                                width: 60.w,
                                decoration: BoxDecoration(
                                  color: dark
                                      ? EColors.primaryColor
                                          .withValues(alpha: 0.1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.delete, size: 24.sp),
                                  color: dark ? EColors.white : Colors.black,
                                  onPressed: () =>
                                      _showDeleteDialog(context, dark, index),
                                ),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _toggleHabit(index);
                            },
                            child: Container(
                              height: 100.h,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.h, horizontal: 16.w),
                              padding: EdgeInsets.all(8.w), // Reduced padding
                              decoration: BoxDecoration(
                                color: dark
                                    ? EColors.primaryColor
                                        .withValues(alpha: 0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: habits[index].isCompleted,
                                        onChanged: (bool? value) {
                                          _toggleHabit(index);
                                        },
                                        activeColor: EColors.primaryColor,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        habits[index].name,
                                        style: TextStyle(
                                          decoration: habits[index].isCompleted
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          color: habits[index].isCompleted
                                              ? Colors.grey
                                              : dark
                                                  ? EColors.white
                                                  : Colors.black,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );

          case const (HabitTrackPageErrorState):
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
                child: EAnimationLoaderWidget(
                    image: EImages.lightLoadingAppLogo,
                    text: "Error. Loading..."),
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
                child: EAnimationLoaderWidget(
                    image: EImages.lightLoadingAppLogo, text: "Loading..."),
              ),
            );
        }
      },
    );
  }

  Future<dynamic> _showDeleteDialog(
      BuildContext context, bool dark, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Habit',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: dark ? EColors.white : Colors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this habit?',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.normal,
              color: dark ? EColors.white : Colors.black,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: dark ? EColors.white : Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: EColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                minimumSize: Size(0.18.sw, 0.04.sh),
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                setState(() {
                  _deleteHabit(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _showEditDialog(BuildContext context, int index, bool dark) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController editController =
            TextEditingController(text: habits[index].name);
        return AlertDialog(
          title: Text(
            'Edit Habit',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: dark ? EColors.white : Colors.black,
            ),
          ),
          content: Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: EColors.primaryColor, // Your cursor color
                selectionColor: EColors.primaryColor
                    .withValues(alpha: 0.3), // Text selection color
                selectionHandleColor:
                    EColors.primaryColor, // Selection handle color
              ),
            ),
            child: TextField(
              controller: editController,
              style: TextStyle(
                color: dark ? EColors.white : Colors.black,
              ),
              decoration: InputDecoration(
                hintText: "Enter new habit name",
                hintStyle: TextStyle(
                  color:
                      dark ? EColors.white.withValues(alpha: 0.5) : Colors.grey,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: dark ? EColors.white : Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: EColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                minimumSize: Size(0.18.sw, 0.04.sh),
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  setState(() {
                    habits[index].name = editController.text;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

Theme _buildDrawer(
    BuildContext context, HabitTrackPageBloc habitTrackPageBloc) {
  final dark = EHelperFunctions.isDarkMode(context);
  List<Map<String, dynamic>> drawerItems = [
    {
      'icon': Icons.account_circle_rounded,
      'title': 'Profile',
      'route': '/profile',
    },
    {
      'icon': Icons.settings_rounded,
      'title': 'Settings',
      'route': '/settings',
    },
    {
      'icon': Icons.bar_chart_rounded,
      'title': 'Analytics',
      'route': '/analytics',
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
          backgroundColor: EColors.primaryColor.withValues(alpha: 0.8),
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

  return Theme(
    data: Theme.of(context).copyWith(
      dividerTheme: DividerThemeData(
        color: dark ? Colors.black : EColors.white, // Custom color
        thickness: 0.5, // Adjust thickness
        space: 0, // Remove extra space
      ),
    ),
    child: Drawer(
      backgroundColor: dark ? Colors.black : EColors.white,
      width: 0.65.sw,
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
                Image.asset(
                  EImages.appLogo,
                  height: 136.h,
                  width: 136.h,
                ),
                //   Text(
                //     'Zenova',
                //     style: TextStyle(
                //       fontSize: 24.0.sp,
                //       fontWeight: FontWeight.w600,
                //       color: Colors.black,
                //     ),
                //   ),
                //   Text(
                //     'Unlock Your Potential.',
                //     style: TextStyle(
                //       fontSize: 12.0.sp,
                //       fontWeight: FontWeight.w500,
                //       color: Colors.black,
                //       fontFamily: GoogleFonts.poppins().fontFamily,
                //     ),
                //   ),
              ],
            ),
          ),

          /// Drawer Items
          ...drawerItems.map(buildListTile),
        ],
      ),
    ),
  );
}

class Habit {
  String name;
  bool isCompleted;

  Habit({required this.name, required this.isCompleted});
}
