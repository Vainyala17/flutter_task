import 'package:dio/dio.dart';
import '../models/post.dart';
import '../models/todo.dart';
import '../models/user.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com/'));

  Future<List<User>> fetchUsers({int limit = 10, int skip = 0}) async {
    final response = await _dio.get('/users', queryParameters: {
      'limit': limit,
      'skip': skip,
    });

    // Parse response and return List<User>
    final List<dynamic> users = response.data['users'];
    return users.map((user) => User.fromJson(user)).toList();
  }

  Future<List<Post>> fetchPosts(int userId) async {
    final response = await _dio.get('/posts/user/$userId');

    // Parse response and return List<Post>
    final List<dynamic> posts = response.data['posts'];
    return posts.map((post) => Post.fromJson(post)).toList();
  }

  Future<List<Todo>> fetchTodos(int userId) async {
    final response = await _dio.get('/todos/user/$userId');

    // Parse response and return List<Todo>
    final List<dynamic> todos = response.data['todos'];
    return todos.map((todo) => Todo.fromJson(todo)).toList();
  }
}