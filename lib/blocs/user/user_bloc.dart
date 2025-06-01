import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/api_service.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiService _apiService;
  static const int _pageSize = 30;
  Timer? _debounceTimer;

  UserBloc({required ApiService apiService})
      : _apiService = apiService,
        super(const UserState()) {
    on<FetchUsersEvent>(_onFetchUsers);
    on<LoadMoreUsersEvent>(_onLoadMoreUsers);
    on<SearchUsersEvent>(_onSearchUsers);
    on<ClearSearchEvent>(_onClearSearch);
    on<RefreshUsersEvent>(_onRefreshUsers);
  }

  Future<void> _onFetchUsers(FetchUsersEvent event,
      Emitter<UserState> emit,) async {
    if (state.hasReachedMax && !event.isRefresh) return;

    try {
      if (state.status == UserStatus.initial || event.isRefresh) {
        emit(state.copyWith(status: UserStatus.loading));

        final response = await _apiService.fetchUsers(
          limit: _pageSize,
          skip: 0,
        );

        emit(state.copyWith(
          status: UserStatus.success,
          users: response.users,
          hasReachedMax: response.users.length < _pageSize,
          currentPage: 1,
          totalUsers: response.total,
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        status: UserStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreUsers(LoadMoreUsersEvent event,
      Emitter<UserState> emit,) async {
    if (state.hasReachedMax || state.status == UserStatus.loadingMore) return;

    try {
      emit(state.copyWith(status: UserStatus.loadingMore));

      final skip = state.users.length;

      final response = state.isSearching
          ? await _apiService.searchUsers(
        query: state.searchQuery,
        limit: _pageSize,
        skip: skip,
      )
          : await _apiService.fetchUsers(
        limit: _pageSize,
        skip: skip,
      );

      final newUsers = List.of(state.users)
        ..addAll(response.users);

      emit(state.copyWith(
        status: UserStatus.success,
        users: newUsers,
        hasReachedMax: response.users.length < _pageSize,
        currentPage: state.currentPage + 1,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: UserStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onSearchUsers(SearchUsersEvent event,
      Emitter<UserState> emit,) async {
    // Cancel previous debounce timer
    _debounceTimer?.cancel();

    // Start new debounce timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        emit(state.copyWith(
          status: UserStatus.loading,
          searchQuery: event.query,
          isSearching: event.query.isNotEmpty,
        ));

        if (event.query.isEmpty) {
          // If search query is empty, fetch all users
          final response = await _apiService.fetchUsers(
            limit: _pageSize,
            skip: 0,
          );

          emit(state.copyWith(
            status: UserStatus.success,
            users: response.users,
            hasReachedMax: response.users.length < _pageSize,
            searchQuery: '',
            isSearching: false,
            currentPage: 1,
            totalUsers: response.total,
          ));
        } else {
          // Search for users
          final response = await _apiService.searchUsers(
            query: event.query,
            limit: _pageSize,
            skip: 0,
          );

          emit(state.copyWith(
            status: UserStatus.success,
            users: response.users,
            hasReachedMax: response.users.length < _pageSize,
            currentPage: 1,
            totalUsers: response.total,
          ));
        }
      } catch (error) {
        emit(state.copyWith(
          status: UserStatus.failure,
          errorMessage: error.toString(),
        ));
      }
    });
  }

  Future<void> _onClearSearch(ClearSearchEvent event,
      Emitter<UserState> emit,) async {
    _debounceTimer?.cancel();

    try {
      emit(state.copyWith(
        status: UserStatus.loading,
        searchQuery: '',
        isSearching: false,
      ));

      final response = await _apiService.fetchUsers(
        limit: _pageSize,
        skip: 0,
      );

      emit(state.copyWith(
        status: UserStatus.success,
        users: response.users,
        hasReachedMax: response.users.length < _pageSize,
        currentPage: 1,
        totalUsers: response.total,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: UserStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onRefreshUsers(RefreshUsersEvent event,
      Emitter<UserState> emit,) async {
    add(const FetchUsersEvent(isRefresh: true));
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}