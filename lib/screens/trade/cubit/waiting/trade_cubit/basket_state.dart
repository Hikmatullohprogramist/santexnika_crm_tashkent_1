
import 'package:flutter/cupertino.dart';

import '../../../../../models/basket/basket.dart';

@immutable
abstract class BasketState {}

class BasketInitial extends BasketState {}

class BasketLoading extends BasketState {}

class BasketSuccess extends BasketState {
  final OrderModel orderList;
   BasketSuccess(this.orderList );
}

class BasketSuccessCheck extends BasketState{
  String checkId;

  BasketSuccessCheck(this.checkId);
}

class BasketError extends BasketState {
  final String error;
  BasketError(this.error);
}

class BasketEmpty extends BasketState {}
