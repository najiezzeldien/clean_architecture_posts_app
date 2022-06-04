import 'package:bloc/bloc.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/failures.dart';
import '../../../domain/entities/post.dart';
import '../../../domain/usecases/get_all_posts.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetAllPostUsecase getAllPosts;
  PostsBloc({required this.getAllPosts}) : super(PostsInitial()) {
    on<PostsEvent>((event, emit) async {
      if (event is GetAllPostsEvent) {
        emit(LoadingPostsState());
        final failureOrPosts = await getAllPosts.call();
        emit(_mapFailureOrPostsToState(failureOrPosts));
      } else if (event is RefreshPostsEvent) {
        emit(LoadingPostsState());
        final failureOrPosts = await getAllPosts.call();

        emit(_mapFailureOrPostsToState(failureOrPosts));
      }
    });
  }
  PostsState _mapFailureOrPostsToState(Either<Failure, List<Post>> either) {
    return either.fold(
      (failure) => ErrorPostsState(message: _mapFailureToMessage(failure)!),
      (posts) => LoadedPostsState(posts: posts),
    );
  }

  String? _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case Serverfailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case Offlinefailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        "Unexpected Error , Please try again later";
    }
  }
}
