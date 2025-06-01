import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/api_service.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final ApiService _apiService;

  TodoBloc({required ApiService apiService})
      : _apiService = apiService,
        super(const TodoState()) {

    on<FetchTodosEvent>(_onFetchTodos);
    on<ToggleTodoEvent>(_onToggleTodo);
    on<ClearTodosEvent>(_onClearTodos);
  }

  Future<void> _onFetchTodos(
      FetchTodosEvent event,
      Emitter<TodoState> emit,
      ) async {
    try {
      emit(state.copyWith(
        status: TodoStatus.loading,
        currentUserId: event.userId,
      ));

      final response = await _apiService.fetchTodosByUserId(event.userId);

      emit(state.copyWith(
        status: TodoStatus.success,
        todos: response.todos,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: TodoStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onToggleTodo(
      ToggleTodoEvent event,
      Emitter<TodoState> emit,
      ) async {
    try {
      final updatedTodos = state.todos.map((todo) {
        if (todo.id == event.todoId) {
          return todo.copyWith(completed: !todo.completed);
        }
        return todo;
      }).toList();

      emit(state.copyWith(
        status: TodoStatus.success,
        todos: updatedTodos,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: TodoStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onClearTodos(
      ClearTodosEvent event,
      Emitter<TodoState> emit,
      ) async {
    emit(state.copyWith(
      status: TodoStatus.initial,
      todos: [],
      errorMessage: null,
      currentUserId: null,
    ));
  }
}