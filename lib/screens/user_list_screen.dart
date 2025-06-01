import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../blocs/user/user_bloc.dart';
import '../blocs/user/user_event.dart';
import '../blocs/user/user_state.dart';
import '../widgets/user_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import 'user_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<UserBloc>().add(const FetchUsersEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<UserBloc>().add(const LoadMoreUsersEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onRefresh() {
    context.read<UserBloc>().add(const RefreshUsersEvent());
  }

  void _onSearchChanged(String query) {
    context.read<UserBloc>().add(SearchUsersEvent(query));
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<UserBloc>().add(const ClearSearchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              // Toggle theme - this would require theme management
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Theme toggle feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users by name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
                    : null,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          // User List
          Expanded(
            child: BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {
                if (state.status == UserStatus.success) {
                  _refreshController.refreshCompleted();
                } else if (state.status == UserStatus.failure) {
                  _refreshController.refreshFailed();
                  if (state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case UserStatus.initial:
                  case UserStatus.loading:
                    return const Center(child: LoadingWidget());

                  case UserStatus.failure:
                    return CustomErrorWidget(
                      message: state.errorMessage ?? 'Something went wrong',
                      onRetry: () {
                        context.read<UserBloc>().add(const FetchUsersEvent());
                      },
                    );

                  case UserStatus.success:
                  case UserStatus.loadingMore:
                    if (state.users.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No users found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return SmartRefresher(
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.hasReachedMax
                            ? state.users.length
                            : state.users.length + 1,
                        itemBuilder: (context, index) {
                          if (index >= state.users.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: LoadingWidget()),
                            );
                          }

                          final user = state.users[index];
                          return UserCard(
                            user: user,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDetailScreen(user: user),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}