// lib/services/blog_service.dart
import 'dart:convert';

class BlogService {
  Future<List<BlogPost>> getBlogPosts() async {
    // Simulate a delay for fetching posts
    await Future.delayed(const Duration(seconds: 2));

    // Dummy blog data for testing
    final response = jsonEncode([
      {
        'id': 1,
        'title': 'Empowering Women Through Technology:',
        'content': 'Women’s safety has long been a pressing issue, not just in India but globally. Despite advances in technology, education, and awareness, many women still face dangers on a daily basis, whether in public spaces or even within the confines of their homes. The key to addressing this issue lies in empowering women with tools that can provide real-time assistance during crises, and that’s where resq.ai, our SOS app, steps in.',
      },
      {
        'id': 2,
        'title': 'What is resq.ai?',
        'content': 'resq.ai is a next-generation SOS app, developed with the primary goal of ensuring women’s safety in real-time. It offers a suite of features designed to protect and assist users when they find themselves in vulnerable situations.',
      },
      {
        'id': 3,
        'title': 'How resq.ai Empowers Women',
        'content': ' Control Over Their Safety: resq.ai allows women to take charge of their own safety. No longer do they have to wait for help to arrive or depend solely on public safety systems. With just a tap, they can activate a lifeline, connecting them to family, friends, and local authorities.',
      },
    ]);

    // Decode the response and convert to list of blog posts
    List<BlogPost> blogPosts = (jsonDecode(response) as List)
        .map((data) => BlogPost.fromJson(data))
        .toList();

    return blogPosts;
  }

  Future<void> addBlogPost(BlogPost blogPost) async {
    // For now, this method is unused but could be implemented for adding posts
  }
}

class BlogPost {
  int id;
  String title;
  String content;

  BlogPost({required this.id, required this.title, required this.content});

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }
}
