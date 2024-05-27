
import 'package:flutter/cupertino.dart';

import '../../../../../models/orders/waitingOrderModel.dart';

@immutable
abstract class WaitingState {}

class WaitingInitial extends WaitingState {}

class WaitingLoadingState extends WaitingState {}

class WaitingSuccessState extends WaitingState {
  final String message;

  WaitingSuccessState(this.message);
}

class WaitingErrorState extends WaitingState {
  final String message;

  WaitingErrorState(this.message);
}

class WaitingOrdersSuccessState extends WaitingState {
  final List<WaitingOrderModel> data;

  WaitingOrdersSuccessState(this.data);
}




