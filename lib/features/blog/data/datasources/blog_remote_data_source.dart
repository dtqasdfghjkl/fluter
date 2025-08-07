import 'dart:io';

import 'package:flutter_app/core/error/exceptions.dart';
import 'package:flutter_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
  Future<List<BlogModel>> getAllBlog();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .insert(blog.toJson())
          .select().single();
      return BlogModel.fromJson(blogData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<String> uploadBlogImage({required File image, required BlogModel blog}) async {
    try {
      final path = blog.id;
      await supabaseClient.storage.from('blog_images').upload(path, image);
      return supabaseClient.storage.from('blog_images').getPublicUrl(path);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<List<BlogModel>> getAllBlog() async {
    try {
      final blogs = await supabaseClient.from('blogs').select('*, profiles (name)');

      return blogs.map((blog) => BlogModel.fromJson(blog)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
