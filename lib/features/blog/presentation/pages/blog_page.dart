import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/common/widgets/loader.dart';
import 'package:flutter_app/core/theme/app_pallete.dart';
import 'package:flutter_app/core/utils/show_snackbar.dart';
import 'package:flutter_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:flutter_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const blogColor = [
  AppPallete.gradient1,
  AppPallete.gradient2,
  AppPallete.gradient3,
];

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogGetAll());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Page'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.add_circled),
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Loader();
          }
          if (state is BlogsDisplaySuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(blog: blog, color: blogColor[index % 3]);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
