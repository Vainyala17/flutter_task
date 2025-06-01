import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/api_service.dart';
import '../../models/post.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final ApiService _apiService;

  PostBloc({required ApiService apiService})
      : _apiService = apiService,
        super(const PostState()) {

    on<FetchPostsEvent>(_onFetchPosts);
    on<CreatePostEvent>(_onCreatePost);
    on<AddLocalPostEvent>(_onAddLocalPost);
    on<ClearPostsEvent>(_onClearPosts);
  }

  Future<void> _onFetchPosts(
      FetchPostsEvent event,
      Emitter<PostState> emit,
      ) async {
    try {
      emit(state.copyWith(
        status: PostStatus.loading,
        currentUserId: event.userId,
      ));

      final response = await _apiService.fetchPostsByUserId(event.userId);

      // Combine API posts with local posts for this user
      final localPosts = state.posts
          .where((post) => post.isLocal && post.userId == event.userId)
          .toList();

      final allPosts = [...localPosts, ...response.posts];

      emit(state.copyWith(
        status: PostStatus.success,
        posts: allPosts,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: PostStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onCreatePost(
      CreatePostEvent event,
      Emitter<PostState> emit,
      ) async {
    try {
      emit(state.copyWith(status: PostStatus.creating));

      // Try to create post via API (DummyJSON simulates this)
      final newPost = await _apiService.createPost(
        title: event.title,
        body: event.body,
        userId: event.userId,
      );

      // Add the new post to the beginning of the list
      final updatedPosts = [newPost, ...state.posts];

      emit(state.copyWith(
        status: PostStatus.success,
        posts: updatedPosts,
      ));
    } catch (error) {
      // If API call fails, create local post instead
      add(AddLocalPostEvent(
        title: event.title,
        body: event.body,
        userId: event.userId,
      ));
    }
  }

  Future<void> _onAddLocalPost(
      AddLocalPostEvent event,
      Emitter<PostState> emit,
      ) async {
    try {
      final localPost = Post.createLocal(
        title: event.title,
        body: event.body,
        userId: event.userId,
      );

      // Add the new local post to the beginning of the list
      final updatedPosts = [localPost, ...state.posts];

      emit(state.copyWith(
        status: PostStatus.success,
        posts: updatedPosts,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: PostStatus.failure,
        errorMessage: 'Failed to create local post: ${error.toString()}',
      ));
    }
  }

  Future<void> _onClearPosts(
      ClearPostsEvent event,
      Emitter<PostState> emit,
      ) async {
    emit(state.copyWith(
      status: PostStatus.initial,
      posts: [],
      errorMessage: null,
      currentUserId: null,
    ));
  }
}