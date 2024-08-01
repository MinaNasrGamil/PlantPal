import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../constants/enums.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/plant_repository.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PlantRepository plantRepository;
  PostCubit(this.plantRepository) : super(PostState.inital()) {
    fechPostsData();
    fechUserImageUrl();
  }

  Future<void> fechPostsData() async {
    emit(state.copyWith(postStatus: Status.looding));
    try {
      final posts = await plantRepository.fetchPostsData();
      emit(state.copyWith(postStatus: Status.success, posts: posts));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(postStatus: Status.error));
    }
  }

  Future<void> fechUserImageUrl() async {
    emit(state.copyWith(postStatus: Status.looding));
    try {
      final imageUrl = await plantRepository.fetchUserImageUrl();
      emit(state.copyWith(postStatus: Status.success, userImageUrl: imageUrl));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(postStatus: Status.error));
    }
  }

  Future<void> createPost(
      String paragraph, File? image, String autherImageUrl) async {
    emit(state.copyWith(postStatus: Status.looding));
    try {
      await plantRepository
          .createPost(paragraph, image, autherImageUrl)
          .then((value) {
        fechPostsData();
      });
      emit(state.copyWith(postStatus: Status.success));
    } catch (e) {
      debugPrint('error in createPost :$e');
      emit(state.copyWith(postStatus: Status.error));
    }
  }

  Future<void> addUserImage(File image) async {
    emit(state.copyWith(imageStatus: Status.looding));
    try {
      await plantRepository.uploadAndSaveUserImage(image).then((value) {
        fechUserImageUrl();
        fechPostsData();
      });
      emit(state.copyWith(imageStatus: Status.success));
    } catch (e) {
      debugPrint('error in createPost :$e');
      emit(state.copyWith(imageStatus: Status.error));
    }
  }

  Future<void> postLike(List liks, String postId) async {
    emit(state.copyWith(likeStatus: Status.looding));

    await plantRepository.postLike(liks, postId).then((value) {
      fechPostsData();
    });
    try {
      emit(state.copyWith(likeStatus: Status.success));
    } catch (e) {
      debugPrint('error in createPost :$e');
      emit(state.copyWith(likeStatus: Status.error));
    }
  }

  Future<void> addComment(String text, String postId) async {
    emit(state.copyWith(commentStatus: Status.looding));
    try {
      await plantRepository.addComment(postId, text).then((value) {
        fechPostsData();
      });
      emit(state.copyWith(commentStatus: Status.success));
    } catch (e) {
      debugPrint('error in createPost :$e');
      emit(state.copyWith(commentStatus: Status.error));
    }
  }
}
