import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String title;
  final String body;
  final int userId;
  final List<String> tags;
  final Reactions reactions;
  final int views;
  final bool isLocal; // For locally created posts

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.tags,
    required this.reactions,
    required this.views,
    this.isLocal = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userId: json['userId'] ?? 0,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      reactions: Reactions.fromJson(json['reactions'] ?? {}),
      views: json['views'] ?? 0,
      isLocal: json['isLocal'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userId': userId,
      'tags': tags,
      'reactions': reactions.toJson(),
      'views': views,
      'isLocal': isLocal,
    };
  }

  // Create a local post
  factory Post.createLocal({
    required String title,
    required String body,
    required int userId,
  }) {
    return Post(
      id: DateTime.now().millisecondsSinceEpoch, // Temporary ID
      title: title,
      body: body,
      userId: userId,
      tags: [],
      reactions: const Reactions(likes: 0, dislikes: 0),
      views: 0,
      isLocal: true,
    );
  }

  Post copyWith({
    int? id,
    String? title,
    String? body,
    int? userId,
    List<String>? tags,
    Reactions? reactions,
    int? views,
    bool? isLocal,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      userId: userId ?? this.userId,
      tags: tags ?? this.tags,
      reactions: reactions ?? this.reactions,
      views: views ?? this.views,
      isLocal: isLocal ?? this.isLocal,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    userId,
    tags,
    reactions,
    views,
    isLocal,
  ];
}

class Reactions extends Equatable {
  final int likes;
  final int dislikes;

  const Reactions({
    required this.likes,
    required this.dislikes,
  });

  factory Reactions.fromJson(Map<String, dynamic> json) {
    return Reactions(
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likes': likes,
      'dislikes': dislikes,
    };
  }

  @override
  List<Object?> get props => [likes, dislikes];
}

class PostsResponse extends Equatable {
  final List<Post> posts;
  final int total;
  final int skip;
  final int limit;

  const PostsResponse({
    required this.posts,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory PostsResponse.fromJson(Map<String, dynamic> json) {
    return PostsResponse(
      posts: (json['posts'] as List<dynamic>?)
          ?.map((post) => Post.fromJson(post))
          .toList() ??
          [],
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [posts, total, skip, limit];
}