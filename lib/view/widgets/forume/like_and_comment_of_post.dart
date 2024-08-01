import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/enums.dart';
import '../../../data/models/post_model.dart';
import '../../../logic/cubit/userPost/post_cubit.dart';

class LikeAndCommentOfPost extends StatefulWidget {
  const LikeAndCommentOfPost({
    super.key,
    required this.post,
  });

  final PostModel post;

  @override
  State<LikeAndCommentOfPost> createState() => _LikeAndCommentOfPostState();
}

class _LikeAndCommentOfPostState extends State<LikeAndCommentOfPost> {
  final TextEditingController _controller = TextEditingController();

  void _addComment(BuildContext context, String postId) {
    String text = _controller.text;
    if (text.isNotEmpty) {
      context.read<PostCubit>().addComment(text, postId);
      print('Sending: $text');

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon:
              widget.post.likes.contains(FirebaseAuth.instance.currentUser!.uid)
                  ? const Icon(
                      Icons.thumb_up_alt,
                      color: Colors.blue,
                    )
                  : const Icon(Icons.thumb_up_alt_outlined),
          onPressed: () {
            context
                .read<PostCubit>()
                .postLike(widget.post.likes, widget.post.postId);
          },
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.centerRight,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                ),
                controller: _controller,
              ),
              Positioned(
                right: 0,
                child: BlocBuilder<PostCubit, PostState>(
                  buildWhen: (previous, current) =>
                      previous.commentStatus != current.commentStatus,
                  builder: (context, state) {
                    return state.commentStatus == Status.looding
                        ? const CircularProgressIndicator()
                        : IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              _addComment(context, widget.post.postId);
                            },
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
