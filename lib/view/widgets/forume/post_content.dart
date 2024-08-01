import 'package:flutter/material.dart';

import '../../../data/models/post_model.dart';

class PostContent extends StatelessWidget {
  const PostContent({
    super.key,
    required this.post,
    required this.numOfComments,
  });

  final PostModel post;
  final int numOfComments;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed('/postdetails');
      },
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.paragraph,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 8,
          ),
          post.imageUrl == ''
              ? const SizedBox()
              : Center(child: Image.network(post.imageUrl))
        ],
      ),
      subtitle: Row(
        children: [
          Text(
            '${post.likes.length} likes   ',
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            '$numOfComments comments',
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
