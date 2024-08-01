import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/enums.dart';
import '../../logic/cubit/userPost/post_cubit.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      _showImageDialog();
    }
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selected Image'),
          content: _selectedImage != null
              ? Image.file(_selectedImage!)
              : const Text('No image selected'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (_selectedImage != null) {
                  context.read<PostCubit>().addUserImage(_selectedImage!);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0),
      child: Stack(
        children: [
          Positioned(
            top: 16.0,
            left: 16.0,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 125,
                    width: 125,
                    child: Stack(
                      children: [
                        BlocBuilder<PostCubit, PostState>(
                          builder: (context, state) {
                            return state.imageStatus == Status.looding
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : CircleAvatar(
                                    radius: 70,
                                    backgroundColor: Colors.blueGrey[100],
                                    backgroundImage: state.userImageUrl != ''
                                        ? NetworkImage(state.userImageUrl)
                                        : null,
                                    child: state.userImageUrl == ''
                                        ? const Icon(Icons.person, size: 70)
                                        : null,
                                  );
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(15)),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt_rounded,
                                  color: Colors.black),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: _pickImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32),
                    child: Text(
                      FirebaseAuth.instance.currentUser?.displayName ?? '',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
