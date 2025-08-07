import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_pallete.dart';
import 'package:flutter_app/core/utils/caculate_reading_time.dart';
import 'package:flutter_app/features/blog/domain/entities/blog.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: blog.topics
                      .map(
                        (tag) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Chip(label: Text(tag)),
                        ),
                      )
                      .toList(),
                ),
              ),
              Text(
                blog.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          Text('${calculateReadingTime(blog.content)} m'),
        ],
      ),
    );
  }
}
