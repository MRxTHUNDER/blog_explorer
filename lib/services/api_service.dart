import 'dart:convert';
import 'package:blog_explorer/ignore.dart';
import 'package:http/http.dart' as http;
import '../models/blog.dart';

class ApiService {
  final String _baseUrl = 'https://intent-kit-16.hasura.app/api/rest/blogs';
  final Map<String, String> _headers = {
    'x-hasura-admin-secret': adminSecret,
  };

  Future<List<Blog>> fetchBlogs() async {
    final response = await http.get(Uri.parse(_baseUrl), headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Blog> blogs = (data['blogs'] as List).map((blog) => Blog.fromJson(blog)).toList();
      return blogs;
    } else {
      throw Exception('Failed to load blogs');
    }
  }
}
