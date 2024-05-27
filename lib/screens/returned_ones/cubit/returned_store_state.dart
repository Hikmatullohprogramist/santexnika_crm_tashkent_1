part of 'returned_store_cubit.dart';

@immutable
abstract class ReturnedStoreState {}

class ReturnedStoreInitial extends ReturnedStoreState {}

class ReturnedStoreLoadingState extends ReturnedStoreState {}

class ReturnedStoreSuccessState extends ReturnedStoreState {
  final BaseModel<List<ReturnedStoreModel>> data;

    ReturnedStoreSuccessState(this.data);
}
class ReturnedStoreSearchSuccessState extends ReturnedStoreState {
  final BaseModel<List<ReturnedStoreModel>> data;

  ReturnedStoreSearchSuccessState(this.data);
}
class ReturnedStoreSuccessForPostState extends ReturnedStoreState {
  final ReturnedStoreModel data;

  ReturnedStoreSuccessForPostState(this.data);
}

class ReturnedStoreErrorState extends ReturnedStoreState {
  final String error;

  ReturnedStoreErrorState(this.error);
}
