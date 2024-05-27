part of 'price_cubit.dart';

@immutable
abstract class PriceState {}

class PriceInitial extends PriceState {}

class PriceLoadingState extends PriceState {}

class PriceSuccessState extends PriceState {
  final List<PriceModel> data;

  PriceSuccessState(this.data);
}

class PriceErrorState extends PriceState {
  final String error;

  PriceErrorState(this.error);
}
