import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginRepository {
  final String apiUrl;

  LoginRepository({bool useDev = true})
      : apiUrl = useDev ? dotenv.env['DEV_URL']! : dotenv.env['BASE_URL']!;

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final url = Uri.parse('$apiUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
          'user': data['user'],
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['error'] ?? 'Unknown error',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Something went wrong. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> sendOtp(String email) async {
  final url = Uri.parse('$apiUrl/otp/send-otp');

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': body['message'] ?? "OTP sent successfully",
      };
    } else {
      return {
        'success': false,
        'error': body['error'] ?? body['message'] ?? "Failed to send OTP",
      };
    }
  } catch (e) {
    return {
      'success': false,
      'error': "Failed to send OTP. Please try again.",
    };
  }
}
}
