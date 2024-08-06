part of 'blog_bloc.dart';

@immutable
abstract class BlogEvent {}

class LoadBlogs extends BlogEvent {}

class LoadMoreBlogs extends BlogEvent {}

class MarkAsFavorite extends BlogEvent {
  final Blog blog;

  MarkAsFavorite({required this.blog});
}
