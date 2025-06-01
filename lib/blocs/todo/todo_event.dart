import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class FetchTodosEvent extends TodoEvent {
  final int userId;

  const FetchTodosEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ToggleTodoEvent extends TodoEvent {
  final int todoId;

  const ToggleTodoEvent(this.todoId);

  @override
  List<Object?> get props => [todoId];
}

class ClearTodosEvent extends TodoEvent {
  const ClearTodosEvent();
}