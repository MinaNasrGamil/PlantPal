import 'package:cloud_firestore/cloud_firestore.dart';

import 'comment_model.dart';

class PostModel {
  final String postId;
  final String paragraph;
  final String imageUrl;
  final List<CommentModel> comments;
  final String autherName;
  String? autherImageUrl;
  final String autherId;
  final Timestamp postTimestamp;
  final List likes;
  final int totalCommentsCount;

  PostModel({
    required this.postId,
    required this.paragraph,
    required this.imageUrl,
    required this.comments,
    required this.autherName,
    this.autherImageUrl,
    required this.autherId,
    required this.postTimestamp,
    required this.likes,
    required this.totalCommentsCount,
  });
}
