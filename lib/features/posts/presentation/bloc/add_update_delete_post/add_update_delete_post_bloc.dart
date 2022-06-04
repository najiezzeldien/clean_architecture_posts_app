import 'package:bloc/bloc.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/strings/messages.dart';
import '../../../domain/entities/post.dart';
import '../../../domain/usecases/add_post.dart';
import '../../../domain/usecases/delete_post.dart';
import '../../../domain/usecases/update_post.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
part 'add_update_delete_post_event.dart';
part 'add_update_delete_post_state.dart';

class AddUpdateDeletePostBloc
    extends Bloc<AddUpdateDeletePostEvent, AddUpdateDeletePostState> {
  final AddPostUsecase addPost;
  final DeletePostUsecase deletePost;
  final UpdatePostUsecase updatePost;
  AddUpdateDeletePostBloc({
    required this.addPost,
    required this.deletePost,
    required this.updatePost,
  }) : super(AddUpdateDeletePostInitial()) {
    on<AddUpdateDeletePostEvent>((event, emit) async {
      if (event is AddPostEvent) {
        emit(LoadingAddUpdateDeletePostState());
        final failureOrDoneMessage = await addPost(event.post);
        emit(_eitherDoneMessageOrErrorState(
          failureOrDoneMessage,
          ADD_SUCCESS_MESSAGE,
        ));
      } else if (event is UpdatePostEvent) {
        emit(LoadingAddUpdateDeletePostState());
        final failureOrDoneMessage = await updatePost(event.post);
        emit(_eitherDoneMessageOrErrorState(
          failureOrDoneMessage,
          UPDATE_SUCCESS_MESSAGE,
        ));
      } else if (event is DeletePostEvent) {
        emit(LoadingAddUpdateDeletePostState());
        final failureOrDoneMessage = await deletePost(event.postId);
        emit(_eitherDoneMessageOrErrorState(
          failureOrDoneMessage,
          DELETE_SUCCESS_MESSAGE,
        ));
      }
    });
  }
  AddUpdateDeletePostState _eitherDoneMessageOrErrorState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
      (failure) => ErrorAddUpdateDeletePostState(
          message: _mapFailureToMessage(failure)!),
      (_) => MessageAddUpdateDeletePostState(message: message),
    );
  }

  String? _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case Serverfailure:
        return SERVER_FAILURE_MESSAGE;

      case Offlinefailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        "Unexpected Error , Please try again later";
    }
  }
}
