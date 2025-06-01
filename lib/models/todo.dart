import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  const Todo({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] ?? 0,
      todo: json['todo'] ?? '',
      completed: json['completed'] ?? false,
      userId: json['userId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': todo,
      'completed': completed,
      'userId': userId,
    };
  }

  Todo copyWith({
    int? id,
    String? todo,
    bool? completed,
    int? userId,
  }) {
    return Todo(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [id, todo, completed, userId];
}

class TodosResponse extends Equatable {
  final List<Todo> todos;
  final int total;
  final int skip;
  final int limit;

  const TodosResponse({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory TodosResponse.fromJson(Map<String, dynamic> json) {
    return TodosResponse(
      todos: (json['todos'] as List<dynamic>?)
          ?.map((todo) => Todo.fromJson(todo))
          .toList() ??
          [],
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [todos, total, skip, limit];
}