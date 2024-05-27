import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/orders/waitingOrderModel.dart';
import 'package:santexnika_crm/screens/trade/cubit/waiting/waiting/waiting_state.dart';
import 'package:santexnika_crm/service/api_service/waiting/waiting.dart';


class WaitingCubit extends Cubit<WaitingState> {
  final WaitingOrderService waitingOrderService = WaitingOrderService();

  WaitingCubit() : super(WaitingInitial()) {
    getWaiting();
  }

  Future<void> getWaiting() async {
    emit(WaitingLoadingState());
    try {
      Either<String, List<WaitingOrderModel>> data =
          await waitingOrderService.getWaiting();
      data.fold(
        (error) => emit(WaitingErrorState(error)),
        (data) => emit(
          data.isNotEmpty
              ? WaitingOrdersSuccessState(data)
              : WaitingErrorState(empty),
        ),
      );
    } catch (e) {
      emit(
        WaitingErrorState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> toWaiting(List basketIds) async {
    emit(WaitingLoadingState());

    try {
      Either<String, String> data =
          await waitingOrderService.toWaiting(basketIds);

      data.fold(
          (error) => emit(
                WaitingErrorState(error),
              ), (data) {
        emit(
          WaitingSuccessState(data),
        );
      });
    } catch (e) {
      emit(
        WaitingErrorState(
          e.toString(),
        ),
      );
    }
  }
}
