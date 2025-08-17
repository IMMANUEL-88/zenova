// analytics_page.dart
import 'package:flutter/material.dart';
import 'package:zenova/pages/analytics/analytics_model.dart';
import 'package:zenova/utils/local_storage/hive_storage_helper.dart';

class Analytics extends StatelessWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context) {
    final analyticsData = HiveStorageHelper.getAnalyticsData();

    if (analyticsData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Analytics')),
        body: Center(child: Text('No analytics data available')),
      );
    }

    // Sort daily analytics by date
    final sortedAnalytics = List<DailyAnalytics>.from(analyticsData.dailyAnalytics)
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(title: Text('Analytics')),
      body: ListView.builder(
        itemCount: sortedAnalytics.length,
        itemBuilder: (context, index) {
          final daily = sortedAnalytics[index];
          final completionPercentage = (daily.completed / daily.total * 100).round();

          return ListTile(
            title: Text(daily.date.toLocal().toString().split(' ')[0]),
            subtitle: LinearProgressIndicator(
              value: daily.completed / daily.total,
            ),
            trailing: Text('$completionPercentage% ($daily.completed/${daily.total})'),
          );
        },
      ),
    );
  }
}
