// analytics_model.dart
import 'package:hive/hive.dart';

part 'analytics_model.g.dart';

@HiveType(typeId: 1)
class AnalyticsData {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final List<DailyAnalytics> dailyAnalytics;

  AnalyticsData({
    required this.id,
    required this.userId,
    required this.dailyAnalytics,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      id: json['_id'],
      userId: json['userId'],
      dailyAnalytics: (json['dailyAnalytics'] as List)
          .map((e) => DailyAnalytics.fromJson(e))
          .toList(),
    );
  }
}

@HiveType(typeId: 2)
class DailyAnalytics {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int completed;

  @HiveField(2)
  final int total;

  DailyAnalytics({
    required this.date,
    required this.completed,
    required this.total,
  });

  factory DailyAnalytics.fromJson(Map<String, dynamic> json) {
    return DailyAnalytics(
      date: DateTime.parse(json['date']),
      completed: json['completed'],
      total: json['total'],
    );
  }
}
