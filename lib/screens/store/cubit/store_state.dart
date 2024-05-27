part of 'store_cubit.dart';

@immutable
abstract class StoreState {}

class StoreInitial extends StoreState {}

class StoreLoadingState extends StoreState {}

class StoreForPaginationLoadingState extends StoreState {}

class StoreForPaginationErrorState extends StoreState {
  final String msg;

  StoreForPaginationErrorState(this.msg);
}

class StoreSuccessState extends StoreState {
  final BaseModel<List<ProductModel>> data;

  StoreSuccessState(this.data);
}

class StoreErrorState extends StoreState {
  final String error;

  StoreErrorState(
    this.error,
  );
}

class StoreDeleteSuccess extends StoreState {
  final String message;

  StoreDeleteSuccess(this.message);
}

class StoreCalculateSuccessState extends StoreState {
  final ProductCalculation data;

  StoreCalculateSuccessState(this.data);
}

class StoreSearchSuccessState extends StoreState {
  final BaseModel<List<ProductModel>> data;

  StoreSearchSuccessState(this.data);
}

class StoreEmptyState extends StoreState {}
