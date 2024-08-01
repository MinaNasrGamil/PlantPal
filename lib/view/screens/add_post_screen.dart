import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/enums.dart';
import '../../logic/cubit/userPost/post_cubit.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitForm(BuildContext context, String atherImageUrl) {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      String text = _textController.text;
      File? image = _image;

      // Do something with the text and image
      print('Image file Path : $image');
      print('auther image url : $atherImageUrl');
      context.read<PostCubit>().createPost(text, image, atherImageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: BlocBuilder<PostCubit, PostState>(
              buildWhen: (previous, current) =>
                  previous.postStatus != current.postStatus,
              builder: (BuildContext context, PostState state) {
                return ElevatedButton(
                    onPressed: state.postStatus == Status.looding
                        ? null
                        : () {
                            _submitForm(context, state.userImageUrl);
                          },
                    child: const Text('Add Post'));
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    TextFormField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: 'Post Text',
                      ),
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: _pickImage,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                _image == null
                    ? const Text('No image selected.')
                    : Image.file(_image!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
