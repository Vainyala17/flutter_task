import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class FetchPostsEvent extends PostEvent {
  final int userId;

  const FetchPostsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreatePostEvent extends PostEvent {
  final String title;
  final String body;
  final int userId;

  const CreatePostEvent({
    required this.title,
    required this.body,
    required this.userId,
  });

  @override
  List<Object?> get props => [title, body, userId];
}

class AddLocalPostEvent extends PostEvent {
  final String title;
  final String body;
  final int userId;

  const AddLocalPostEvent({
    required this.title,
    required this.body,
    required this.userId,
  });

  @override
  List<Object?> get props => [title, body, userId];
}

class ClearPostsEvent extends PostEvent {
  const ClearPostsEvent();
}