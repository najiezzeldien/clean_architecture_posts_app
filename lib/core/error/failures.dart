import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class Offlinefailure extends Failure {
  @override
  List<Object?> get props => [];
}

class Serverfailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EmptyCacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}

/*class WrongDatafailure extends Failure {
  @override
  List<Object?> get props => [];
}*/
