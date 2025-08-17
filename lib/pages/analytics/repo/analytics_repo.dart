// analytics_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:zenova/pages/analytics/analytics_model.dart';

class AnalyticsService {
  static String baseUrl = DotEnv().env['BASE_URL'] ?? 'http://localhost:3000/api';
    static String devUrl = DotEnv().env['DEV_URL'] ?? 'http://localhost:3000/api';


  static Future<AnalyticsData> fetchAnalytics(String userId) async {
    final response = await http.get(Uri.parse('$devUrl/analytics/$userId'));

    if (response.statusCode == 200) {
      return AnalyticsData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load analytics data');
    }
  }
}
