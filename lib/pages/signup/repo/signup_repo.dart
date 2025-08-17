import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignUpRepository {
  final String apiUrl;

  SignUpRepository({bool useDev = true})
      : apiUrl = useDev ? dotenv.env['DEV_URL']! : dotenv.env['BASE_URL']!;

  Future<Map<String, dynamic>> signUpUser(String email, String password, String firstName, String lastName) async {
    final url = Uri.parse('$apiUrl/auth/signup');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        }),
      );

      if (response.statusCode == 201) {
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
}
