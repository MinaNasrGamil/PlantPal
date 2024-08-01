import 'package:flutter/material.dart';

class PostDetailsScreen extends StatefulWidget {
  @override
  _PostDetailsScreenState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  List<String> comments = [];
  bool isLoading = false;
  int commentPage = 0;

  @override
  void initState() {
    super.initState();
    loadComments();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading) {
        loadComments();
      }
    });
  }

  Future<void> loadComments() async {
    setState(() {
      isLoading = true;
    });

    // Simulate a network request
    await Future.delayed(Duration(seconds: 2));

    // Add dummy comments
    List<String> newComments =
        List.generate(10, (index) => 'Comment ${commentPage * 10 + index + 1}');

    setState(() {
      comments.addAll(newComments);
      commentPage++;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Post Title',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    // ignore: lines_longer_than_80_chars
                    'This is the content of the post. It can be quite long and might include multiple paragraphs.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Comments',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= comments.length) {
                  // Show loading indicator if needed
                  return Center(child: CircularProgressIndicator());
                }
                return ListTile(
                  leading: CircleAvatar(
                    radius: 15.0,
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  ),
                  title: Text(comments[index]),
                );
              },
              childCount: comments.length + (isLoading ? 1 : 0),
            ),
          ),
        ],
      ),
    );
  }
}
