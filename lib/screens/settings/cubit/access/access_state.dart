part of 'access_cubit.dart';

@immutable
abstract class AccessState {}

class AccessInitial extends AccessState {}

class AccessLoadingState extends AccessState {}

class AccessSuccessState extends AccessState {
  final List<AccessModel> data;

  AccessSuccessState(this.data);
}

class AccessErrorState extends AccessState {
  final String error;

  AccessErrorState(this.error);
}
