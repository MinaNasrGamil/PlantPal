import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/post_model.dart';

class PostAutherDetails extends StatelessWidget {
  const PostAutherDetails({
    super.key,
    required this.post,
  });

  final PostModel post;

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays < 7) {
      // Show day of the week and day number if within a week
      return DateFormat('EEE, d').format(dateTime);
    } else if (difference.inDays < 365) {
      // Show month name and day number if within a year
      return DateFormat('MMM d').format(dateTime);
    } else {
      // Show year and month if older than a year
      return DateFormat('yyyy MMM').format(dateTime);
    }
  }

  String formatRelativeDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      // Show minutes ago
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      // Show hours ago
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      // Show days ago
      return '${difference.inDays}d';
    } else {
      // Show formatted date
      return formatDateTime(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 20.0, // Adjust size as needed
            backgroundImage: post.autherImageUrl == ''
                ? null
                : NetworkImage(post.autherImageUrl ?? ''),
            backgroundColor: Colors.grey,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.autherName,
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  formatRelativeDateTime(post.postTimestamp.toDate()),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options action
            },
          ),
        ],
      ),
    );
  }
}
