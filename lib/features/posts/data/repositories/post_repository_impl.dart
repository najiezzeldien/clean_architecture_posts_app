import '../../../../core/error/exception.dart';
import '../../../../core/network/network_info.dart';
import '../models/post_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../datasources/post_local_datasource.dart';
import '../datasources/post_remote_data_source.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/posts_repository.dart';

typedef Future<Unit> DeleteOrUpdateOrAddPost();

class PostsRepositoryImpl implements PostsRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  PostsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getAllPost();
        localDataSource.cachePosts(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(Serverfailure());
      }
    } else {
      try {
        final localPosts = await localDataSource.getCachedPosts();
        return Right(localPosts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addPost(Post post) async {
    final PostModel postModel = PostModel(
      title: post.title,
      body: post.body,
    );
    return await _getMessage(
      () async {
        return await remoteDataSource.addPost(postModel);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int PostId) async {
    return await _getMessage(
      () async {
        return await remoteDataSource.deletePost(PostId);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async {
    final PostModel postModel = PostModel(
      id: post.id,
      title: post.title,
      body: post.body,
    );
    return await _getMessage(
      () async {
        return await remoteDataSource.updatePost(postModel);
      },
    );
  }

  Future<Either<Failure, Unit>> _getMessage(
      DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost;
        return Right(unit);
      } on ServerException {
        return Left(Serverfailure());
      }
    } else {
      return Left(Offlinefailure());
    }
  }
}
