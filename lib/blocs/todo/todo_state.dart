import 'package:equatable/equatable.dart';
import '../../models/todo.dart';

enum TodoStatus { initial, loading, success, failure }

class TodoState extends Equatable {
  final TodoStatus status;
  final List<Todo> todos;
  final String? errorMessage;
  final int? currentUserId;

  const TodoState({
    this.status = TodoStatus.initial,
    this.todos = const <Todo>[],
    this.errorMessage,
    this.currentUserId,
  });

  TodoState copyWith({
    TodoStatus? status,
    List<Todo>? todos,
    String? errorMessage,
    int? currentUserId,
  }) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      errorMessage: errorMessage,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    todos,
    errorMessage,
    currentUserId,
  ];
}