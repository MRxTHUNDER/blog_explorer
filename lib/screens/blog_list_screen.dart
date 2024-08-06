import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../blocs/blog_bloc.dart';
import 'blog_detail_screen.dart';

class BlogListScreen extends StatelessWidget {
  const BlogListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 182, 222, 255),
        elevation: 10,
        title: const Center(child: Text('Blog Explorer', style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25
        ),)),
      ),
      body: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BlogLoaded) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return Card(
                  elevation: 10,
                  shadowColor: const Color.fromARGB(255, 173, 218, 255),
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlogDetailScreen(blog: blog),
                                ),
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: blog.imageUrl,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              imageBuilder: (context, imageProvider) => Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlogDetailScreen(blog: blog),
                                  ),
                                );
                              },
                              child: Text(
                                blog.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(
                            blog.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: blog.isFavorite ? Colors.red : const Color.fromARGB(255, 255, 255, 255),
                          ),
                          onPressed: () {
                            context.read<BlogBloc>().add(MarkAsFavorite(blog: blog));
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is BlogError) {
            return Center(child: Text('Failed to load blogs: ${state.message}'));
          }
          return const Center(child: Text('No blogs found'));
        },
      ),
    );
  }
}
