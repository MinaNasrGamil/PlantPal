import 'package:flutter/material.dart';
import 'post_widget.dart';

class CommunityWidget extends StatelessWidget {
  const CommunityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const PostWidget(
      isFromCommunity: true,
    );
  }
}
