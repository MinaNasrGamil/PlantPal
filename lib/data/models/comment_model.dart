class CommentModel {
  final String commentId;
  final String content;
  final List<CommentModel> replies;

  CommentModel({
    required this.commentId,
    required this.content,
    required this.replies,
  });
}
