import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:flutter_app/core/common/widgets/loader.dart';
import 'package:flutter_app/core/constants/constants.dart';
import 'package:flutter_app/core/theme/app_pallete.dart';
import 'package:flutter_app/core/utils/pick_image.dart';
import 'package:flutter_app/core/utils/show_snackbar.dart';
import 'package:flutter_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:flutter_app/features/blog/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
        BlogUpload(
          image: image!,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          posterId: posterId,
          topics: selectedTopics,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.done_rounded),
            onPressed: uploadBlog,
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          } else if (state is BlogSuccess) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        selectImage();
                      },
                      child: image != null
                          ? SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(image!, fit: BoxFit.cover),
                              ),
                            )
                          : DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                color: AppPallete.borderColor,
                                dashPattern: const [20, 4],
                                radius: const Radius.circular(10),
                                strokeCap: StrokeCap.round,
                              ),
                              child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.folder_open, size: 40),
                                    SizedBox(height: 15),
                                    Text(
                                      'Select your image',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Constants.topics
                            .map(
                              (tag) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectedTopics.contains(tag)) {
                                      selectedTopics.remove(tag);
                                    } else {
                                      selectedTopics.add(tag);
                                    }
                                    setState(() {});
                                  },
                                  child: Chip(
                                    label: Text(tag),
                                    color: selectedTopics.contains(tag)
                                        ? const WidgetStatePropertyAll(
                                            AppPallete.gradient1,
                                          )
                                        : null,
                                    side: selectedTopics.contains(tag)
                                        ? null
                                        : BorderSide(
                                            color: AppPallete.borderColor,
                                          ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                    BlogEditor(
                      controller: titleController,
                      hintText: 'Blog title',
                      validator: BlogValidators.validateTitle,
                    ),
                    SizedBox(height: 10),
                    BlogEditor(
                      controller: contentController,
                      hintText: 'Blog content',
                      validator: BlogValidators.validateContent,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
