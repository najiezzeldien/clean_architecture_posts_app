import '../../../domain/entities/post.dart';
import '../../pages/posts_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PostListWidget extends StatelessWidget {
  final List<Post> posts;
  const PostListWidget({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: ((context, index) {
        return ListTile(
          leading: Text(posts[index].id.toString()),
          title: Text(
            posts[index].title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            posts[index].body,
            style: TextStyle(fontSize: 16),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PostDetailPage(post: posts[index]),
              ),
            );
          },
        );
      }),
      separatorBuilder: (context, index) => Divider(
        thickness: 1,
      ),
      itemCount: posts.length,
    );
  }
}
