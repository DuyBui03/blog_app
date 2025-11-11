import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:flutter/material.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
          ),
        ],
      ),
      body: const Center(child: Text('Welcome to the Blog Page!')),
    );
  }
}
