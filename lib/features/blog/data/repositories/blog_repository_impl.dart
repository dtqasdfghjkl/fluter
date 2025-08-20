import 'dart:io';

import 'package:flutter_app/core/constants/constants.dart';
import 'package:flutter_app/core/error/exceptions.dart';
import 'package:flutter_app/core/error/failures.dart';
import 'package:flutter_app/core/network/connection_checker.dart';
import 'package:flutter_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:flutter_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:flutter_app/features/blog/data/models/blog_model.dart';
import 'package:flutter_app/features/blog/domain/entities/blog.dart';
import 'package:flutter_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    this.blogLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return Left(Failure(Constants.noConnectionMessage));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      final uploadedBlog = await blogRemoteDataSource.uploadBlog(
        blogModel.copyWith(imageUrl: imageUrl),
      );
      return Right(uploadedBlog);
    } on ServerException catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlog() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final blogs = blogLocalDataSource.loadBlogs();
        return Right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlog();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return Right(blogs);
    } on ServerException catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
