import 'package:equatable/equatable.dart';
import '../../models/post.dart';

enum PostStatus { initial, loading, success, failure, creating }

class PostState extends Equatable {
  final PostStatus status;
  final List<Post> posts;
  final String? errorMessage;
  final int? currentUserId;

  const PostState({
    this.status = PostStatus.initial,
    this.posts = const <Post>[],
    this.errorMessage,
    this.currentUserId,
  });

  PostState copyWith({
    PostStatus? status,
    List<Post>? posts,
    String? errorMessage,
    int? currentUserId,
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage: errorMessage,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    posts,
    errorMessage,
    currentUserId,
  ];
}