class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

  Future<List<User>> fetchUsers({int limit = 10, int skip = 0}) async {
    final response = await _dio.get('/users', queryParameters: {
      'limit': limit,
      'skip': skip,
    });
    // Parse response and return List<User>
  }

  Future<List<Post>> fetchPosts(int userId) async {
    final response = await _dio.get('/posts/user/$userId');
    // Parse response
  }

  Future<List<Todo>> fetchTodos(int userId) async {
    final response = await _dio.get('/todos/user/$userId');
    // Parse response
  }
}
