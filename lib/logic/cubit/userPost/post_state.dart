// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'post_cubit.dart';

class PostState extends Equatable {
  final Status postStatus;
  final Status likeStatus;
  final List<PostModel> posts;
  final String userImageUrl;
  final Status imageStatus;
  final Status commentStatus;

  const PostState({
    required this.postStatus,
    required this.likeStatus,
    required this.posts,
    required this.userImageUrl,
    required this.imageStatus,
    required this.commentStatus,
  });

  factory PostState.inital() {
    return const PostState(
      postStatus: Status.inital,
      posts: [],
      userImageUrl: '',
      likeStatus: Status.inital,
      imageStatus: Status.inital,
      commentStatus: Status.inital,
    );
  }

  @override
  List<Object> get props => [
        postStatus,
        posts,
        userImageUrl,
        likeStatus,
        imageStatus,
        commentStatus,
      ];

  PostState copyWith({
    Status? postStatus,
    Status? likeStatus,
    List<PostModel>? posts,
    String? userImageUrl,
    Status? imageStatus,
    Status? commentStatus,
  }) {
    return PostState(
      postStatus: postStatus ?? this.postStatus,
      posts: posts ?? this.posts,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      likeStatus: likeStatus ?? this.likeStatus,
      imageStatus: imageStatus ?? this.imageStatus,
      commentStatus: commentStatus ?? this.commentStatus,
    );
  }
}
