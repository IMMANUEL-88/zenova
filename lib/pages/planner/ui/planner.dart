import 'package:flutter/material.dart';
import 'package:zenova/constants/colors.dart';
import 'package:zenova/helper/helper_functions.dart';
import 'package:zenova/utils/appbar.dart';

class Planner extends StatefulWidget {
  const Planner({super.key});

  @override
  State<Planner> createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: EAppBar(
        title: Text(
          'Planner',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leadingIcon: Icons.menu_rounded,
        leadingOnPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      body: Center(
        child: Text(
          'Planner Page',
          style: TextStyle(
              fontSize: 24, color: dark ? EColors.white : Colors.black),
        ),
      ),
    );
  }
}
