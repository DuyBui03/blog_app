import 'dart:io';

import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:flutter/material.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
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

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.check))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              image != null ?  Image.file(image!) :
              GestureDetector(
                onTap: selectImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppPalette.borderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.folder_open,
                          size: 40,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        const Text('Select your image'),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      ['Entertaiment', 'Business', 'Technology', 'Progamming']
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (selectedTopics.contains(e)) {
                                    selectedTopics.remove(e);
                                  } else {
                                    selectedTopics.add(e);
                                  }
                                  setState(() {});
                                },
                                child: Chip(
                                  color:
                                      selectedTopics.contains(e)
                                          ? const MaterialStatePropertyAll(
                                            AppPalette.gradient1,
                                          )
                                          : null,
                                  label: Text(e),
                                  side:
                                      selectedTopics.contains(e)
                                          ? null
                                          : const BorderSide(
                                            color: AppPalette.borderColor,
                                          ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
              SizedBox(height: 16),
              BlogEditor(controller: titleController, hintText: 'Blog Title'),
              SizedBox(height: 16),
              BlogEditor(
                controller: contentController,
                hintText: 'Blog Content',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
