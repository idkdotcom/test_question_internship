import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:suitmedia_test/models/user.dart';

class UserService {
  static const String baseUrl = 'https://reqres.in/api';

  Future<Map<String, dynamic>> getUsers({int page = 1, int perPage = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users?page=$page&per_page=$perPage')
      );

      if(response.statusCode == 200){
        final Map<String, dynamic> data = json.decode(response.body);
        final List<User> users = (data['data'] as List).map((userData) => User.fromJson(userData)).toList();

        return {
          'users': users,
          'total_pages': data['total_pages'],
          'current_page': data['page'],
        };
      } else{
        throw Exception('Faled to load data');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}