part of 'users_cubit.dart';

@immutable
abstract class UsersState {}

class UserInitial extends UsersState {}

class UserLoadingState extends UsersState {}

class UserSuccessState extends UsersState {
  final BaseModel<List<UsersModel>> data;

  UserSuccessState(this.data);
}

class UserErrorState extends UsersState {
  final String error;

  UserErrorState(this.error);
}
class UserEmptyState extends UsersState {

}

class UserPaymentSuccessState extends UsersState {
  final UserPayment data;
  UserPaymentSuccessState(this.data);

}
class UserPaymentErrorState extends UsersState {
  final String error;
  UserPaymentErrorState(this.error);

}
