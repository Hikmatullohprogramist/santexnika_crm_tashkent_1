part of 'waitin_with_id_cubit.dart';

@immutable
abstract class WaitingWithIdState {}

class WaitingWithIdInitial extends WaitingWithIdState {}
class WaitingLoadingWithIdState extends WaitingWithIdState {}
class WaitingSuccessWithIdState extends WaitingWithIdState {
  final WaitingModelWithId data;

  WaitingSuccessWithIdState(this.data);
}
class WaitingErrorWithIdState extends WaitingWithIdState {
  final String message;

  WaitingErrorWithIdState(this.message);
}

