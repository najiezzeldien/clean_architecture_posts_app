import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widget/loading_widget.dart';
import '../../../domain/entities/post.dart';
import '../../bloc/add_update_delete_post/add_update_delete_post_bloc.dart';
import '../../pages/post_add_update_page.dart';
import '../../pages/posts_page.dart';
import 'delete_dialog_widget.dart';
import 'delete_post_btn_widget.dart';
import 'update_post_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailWidget extends StatelessWidget {
  final Post post;
  const PostDetailWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            post.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            height: 50,
          ),
          Text(
            post.body,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Divider(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              UpdatePostBtnWidget(post: post),
              DeletePostBtnWidget(postId: post.id!),
            ],
          )
        ],
      ),
    );
  }
}
