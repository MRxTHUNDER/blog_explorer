//import 'package:blog_explorer/blocs/blog_event.dart';
//import 'package:blog_explorer/blocs/blog_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import '../models/blog.dart';
import '../services/api_service.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends HydratedBloc<BlogEvent, BlogState> {
  final ApiService apiService;

  BlogBloc({required this.apiService}) : super(BlogInitial()) {
    on<LoadBlogs>(_onLoadBlogs);
    on<MarkAsFavorite>(_onMarkAsFavorite);
  }

  void _onLoadBlogs(LoadBlogs event, Emitter<BlogState> emit) async {
    try {
      emit(BlogLoading());
      final blogs = await apiService.fetchBlogs();
      emit(BlogLoaded(blogs: blogs));
    } catch (error) {
      emit(BlogError(message: error.toString()));
    }
  }

  void _onMarkAsFavorite(MarkAsFavorite event, Emitter<BlogState> emit) {
    if (state is BlogLoaded) {
      final updatedBlogs = (state as BlogLoaded).blogs.map((blog) {
        return blog.id == event.blog.id ? event.blog.copyWith(isFavorite: !blog.isFavorite) : blog;
      }).toList();
      emit(BlogLoaded(blogs: updatedBlogs));
    }
  }

  @override
  BlogState fromJson(Map<String, dynamic> json) {
    try {
      final blogs = (json['blogs'] as List).map((e) => Blog.fromJson(e)).toList();
      return BlogLoaded(blogs: blogs);
    } catch (_) {
      return BlogInitial();
    }
  }

  @override
  Map<String, dynamic> toJson(BlogState state) {
    if (state is BlogLoaded) {
      return {'blogs': state.blogs.map((e) => e.toJson()).toList()};
    }
    return {};
  }
}
