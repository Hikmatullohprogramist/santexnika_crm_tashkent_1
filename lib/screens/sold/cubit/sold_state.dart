part of 'sold_cubit.dart';

@immutable
abstract class SoldState {}

class SoldInitial extends SoldState {}

class SoldLoadingState extends SoldState {}

class SoldSuccessState extends SoldState {
  final BaseModel<List<OrdersModel>> data;

  SoldSuccessState(this.data);
}
class SoldSearchSuccessState extends SoldState {
  final BaseModel<List<OrdersModel>> data;

  SoldSearchSuccessState(this.data);
}

class SoldSuccessWithIdState extends SoldState {
  final List<OrdersModel> data;

  SoldSuccessWithIdState(this.data);
}

class SoldWithIDSuccess extends SoldState {
  final OrderWithIdModel data;

  SoldWithIDSuccess(this.data);
}

class SoldErrorState extends SoldState {
  final String error;

  SoldErrorState(this.error);
}

class SoldProductsSuccessState extends SoldState {
  final BaseModel<List<SelledProducts>> data;

  SoldProductsSuccessState(this.data);
}
class SoldProductsErrorState extends SoldState {
  final String error;

  SoldProductsErrorState(this.error);
}
class SoldErrorForPanginationState extends SoldState {
  final String error;

  SoldErrorForPanginationState(this.error);
}
class SoldEmptyState extends SoldState {
}
