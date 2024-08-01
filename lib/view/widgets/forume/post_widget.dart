import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../logic/cubit/userPost/post_cubit.dart';
import '../profile_widget.dart';
import 'like_and_comment_of_post.dart';
import 'post_auther_details.dart';
import 'post_content.dart';

class PostWidget extends StatelessWidget {
  final bool isFromCommunity;

  const PostWidget({super.key, required this.isFromCommunity});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        // Adjust the itemCount to include the custom widget
        final itemCount = state.posts.length + 1;

        return MasonryGridView.count(
          crossAxisCount: 1, // Only one post per row
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index == 0) {
              // Return the custom widget for the first index
              return isFromCommunity ? const SizedBox() : const ProfileWidget();
            } else {
              // Adjust the index to account for the custom widget
              final postIndex = index - 1;
              if (postIndex < state.posts.length) {
                final post = state.posts[postIndex];

                return Card(
                  child: Column(
                    children: [
                      PostAutherDetails(post: post),
                      PostContent(
                          post: post, numOfComments: post.totalCommentsCount),
                      LikeAndCommentOfPost(post: post),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            }
          },
        );
      },
    );
  }
}
