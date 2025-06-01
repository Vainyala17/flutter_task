import 'package:equatable/equatable.dart';
import '../../models/user.dart';

enum UserStatus { initial, loading, success, failure, loadingMore }

class UserState extends Equatable {
  final UserStatus status;
  final List<User> users;
  final String? errorMessage;
  final bool hasReachedMax;
  final String searchQuery;
  final bool isSearching;
  final int currentPage;
  final int totalUsers;

  const UserState({
    this.status = UserStatus.initial,
    this.users = const <User>[],
    this.errorMessage,
    this.hasReachedMax = false,
    this.searchQuery = '',
    this.isSearching = false,
    this.currentPage = 0,
    this.totalUsers = 0,
  });

  UserState copyWith({
    UserStatus? status,
    List<User>? users,
    String? errorMessage,
    bool? hasReachedMax,
    String? searchQuery,
    bool? isSearching,
    int? currentPage,
    int? totalUsers,
  }) {
    return UserState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      currentPage: currentPage ?? this.currentPage,
      totalUsers: totalUsers ?? this.totalUsers,
    );
  }

  @override
  List<Object?> get props => [
    status,
    users,
    errorMessage,
    hasReachedMax,
    searchQuery,
    isSearching,
    currentPage,
    totalUsers,
  ];
}