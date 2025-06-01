import 'package:dio/dio.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../models/todo.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add logging interceptor for debugging
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
  }

  // Fetch users with pagination
  Future<UsersResponse> fetchUsers({
    int limit = 30,
    int skip = 0,
  }) async {
    try {
      final response = await _dio.get(
        '/users',
        queryParameters: {
          'limit': limit,
          'skip': skip,
        },
      );

      if (response.statusCode == 200) {
        return UsersResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch users',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Search users by name
  Future<UsersResponse> searchUsers({
    required String query,
    int limit = 30,
    int skip = 0,
  }) async {
    try {
      final response = await _dio.get(
        '/users/search',
        queryParameters: {
          'q': query,
          'limit': limit,
          'skip': skip,
        },
      );

      if (response.statusCode == 200) {
        return UsersResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to search users',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Fetch user by ID
  Future<User> fetchUserById(int userId) async {
    try {
      final response = await _dio.get('/users/$userId');

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch user',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Fetch posts by user ID
  Future<PostsResponse> fetchPostsByUserId(int userId) async {
    try {
      final response = await _dio.get('/posts/user/$userId');

      if (response.statusCode == 200) {
        return PostsResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch posts',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Fetch todos by user ID
  Future<TodosResponse> fetchTodosByUserId(int userId) async {
    try {
      final response = await _dio.get('/todos/user/$userId');

      if (response.statusCode == 200) {
        return TodosResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch todos',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Create new post (simulated - DummyJSON doesn't actually save)
  Future<Post> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final response = await _dio.post(
        '/posts/add',
        data: {
          'title': title,
          'body': body,
          'userId': userId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Post.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to create post',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Handle Dio errors
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet connection.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 400:
            return Exception('Bad request. Please check your input.');
          case 401:
            return Exception('Unauthorized access.');
          case 403:
            return Exception('Forbidden access.');
          case 404:
            return Exception('Resource not found.');
          case 500:
            return Exception('Internal server error. Please try again later.');
          default:
            return Exception('Server error: ${error.response?.statusMessage}');
        }

      case DioExceptionType.cancel:
        return Exception('Request was cancelled.');

      case DioExceptionType.connectionError:
        return Exception('No internet connection. Please check your network.');

      case DioExceptionType.badCertificate:
        return Exception('Certificate error.');

      case DioExceptionType.unknown:
      default:
        return Exception('Something went wrong. Please try again.');
    }
  }
}