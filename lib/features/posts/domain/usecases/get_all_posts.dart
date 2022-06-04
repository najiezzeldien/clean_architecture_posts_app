import '../../../../core/error/failures.dart';
import '../entities/post.dart';
import '../repositories/posts_repository.dart';

import 'package:dartz/dartz.dart';

class GetAllPostUsecase {
  final PostsRepository repository;

  GetAllPostUsecase(this.repository);

  Future<Either<Failure, List<Post>>> call() async {
    return await repository.getAllPosts();
  }
}
