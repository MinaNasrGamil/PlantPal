import 'package:flutter/material.dart';

import '../widgets/forume/post_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PostWidget(
        isFromCommunity: false,
      ),
    );
  }
}
