part of 'customer_cubit.dart';

@immutable
abstract class CustomerState {}

class CustomerInitial extends CustomerState {}

class CustomerLoadingState extends CustomerState {}

class CustomerForPaginationLoadingState extends CustomerState {}

class CustomerForPaginationErrorState extends CustomerState {
  final String msg;

  CustomerForPaginationErrorState(this.msg);
}

class CustomerSuccessState extends CustomerState {
  final BaseModel<List<CustomerModel>> data;

  CustomerSuccessState(this.data);
}

class CustomerSuccessForPostState extends CustomerState {
  final String? msg;

  CustomerSuccessForPostState(
    this.msg,
  );
}

class CustomerErrorState extends CustomerState {
  final String error;

  CustomerErrorState(this.error);
}

abstract class CustomerWithIdState {}

class CustomerWithIdInitial extends CustomerWithIdState {}

class CustomerLoadingWithIdState extends CustomerWithIdState {}

class CustomerSuccessWithIdState extends CustomerWithIdState {
  final List<CustomerWithId> data;

  CustomerSuccessWithIdState(this.data);
}

class CustomerWithIdSuccessPost extends CustomerWithIdState {
  final String error;

  CustomerWithIdSuccessPost(this.error);
}

class CustomerErrorWithIdState extends CustomerWithIdState {
  final String error;

  CustomerErrorWithIdState(this.error);
}
