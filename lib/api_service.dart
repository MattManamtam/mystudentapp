// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

class ApiService {
  // For Android Emulator: 'http://10.0.2.2:8000/api'
  // For iOS Simulator: 'http://localhost:8000/api'
  // For Real Devices: Replace with your machine's IP address, e.g., 'http://192.168.1.100:8000/api'
  static const String baseUrl = 'http://localhost:8000/api';

  Future<List<Student>> getStudents() async {
    final response = await http.get(Uri.parse('$baseUrl/students'));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      if (body is List) {
        // If the response is a list, parse each student
        return body.map((student) => Student.fromJson(student)).toList();
      } else if (body is Map<String, dynamic> && body.containsKey('message')) {
        // If the response is a map with a message, return an empty list
        return [];
      } else {
        // Unexpected format
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<Student> createStudent(Student student) async {
    final response = await http.post(
      Uri.parse('$baseUrl/students'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(student.toJson()),
    );
    if (response.statusCode == 201) {
      return Student.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create student');
    }
  }

  Future<Student> updateStudent(int id, Student student) async {
    final response = await http.put(
      Uri.parse('$baseUrl/students/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(student.toJson()),
    );
    if (response.statusCode == 200) {
      return Student.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update student');
    }
  }

  Future<void> deleteStudent(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/students/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete student');
    }
  }
}
