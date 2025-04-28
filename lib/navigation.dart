import 'package:flutter/material.dart';
import 'package:zenova/constants/colors.dart';
import 'package:zenova/helper/helper_functions.dart';
import 'package:zenova/pages/habit_track/ui/habit_track.dart';
import 'package:zenova/pages/meditation/ui/meditation.dart';
import 'package:zenova/pages/planner/ui/planner.dart';
import 'package:zenova/pages/zen_focus/ui/zenfocus.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // initialization();
    _pageController = PageController();
  }

  // void initialization() async{
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   FlutterNativeSplash.remove();
  // }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HabitTrack(),
          Meditation(),
          Planner(),
          Zenfocus(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // Ensures all items are visible
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: dark? EColors.white: Colors.black,
        // Active icon color
        unselectedItemColor: dark? EColors.darkGrey:  Colors.black.withValues(alpha: 0.6),
        // Inactive icon color
        backgroundColor: dark? Colors.black: Colors.white,
        // Navbar background color
        elevation: 20,
        // Slight elevation for subtle shadow
        items: [
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Icon(Icons.free_cancellation_rounded, size: 40)
                : Icon(Icons.free_cancellation_outlined, size: 32),
            label: 'Habit',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Icon(Icons.self_improvement_rounded, size: 40)
                : Icon(Icons.self_improvement_sharp, size: 32),
            label: 'Meditation',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? Icon(Icons.calendar_month_rounded, size: 40)
                : Icon(Icons.calendar_month_outlined, size: 32),
            label: 'Planner',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? Icon(Icons.timer_rounded, size: 40)
                : Icon(Icons.timer_outlined, size: 32),
            label: 'Zen Focus',
          ),
        ],
      ),
    );
  }
}
